Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620905A64DD
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiH3Nfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiH3Nfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:35:32 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB95D4B0C1;
        Tue, 30 Aug 2022 06:35:30 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c7so7594069wrp.11;
        Tue, 30 Aug 2022 06:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=JpguWKHCz7w89q6BLLDu3VHzbooJ+x9K5EqEg9fOx8M=;
        b=c2pG9ATJI7Vfg1cNbQDHpSFAphTLeHsKffxD2fhvclwhvmDc8MNye2JlUVbiFLEwyI
         an267YrcHIQxDvJJq3UfNMKVtHmyVegrYXiT4eFRoLbf/ApQADUClSgf4SzlghwDphB9
         51BBe9PZr82GWYUQesDCcL1ol9dmIXPPk5QuqUPcvBNRfEGjiKk61hLof6VNvEefWiIx
         qth/JeKZSuuSYcwR+WN474a/hSBvgy1rEXHXQ2rREECA7TUQtAmg8P+ewovvPqo+XA3P
         2IFOLOKpg2HDOEYA55JiuKtODLt/IPk6TT02zC/Pp9HEpi0LrMYw4DJrNU0qvfCH3eMI
         LAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=JpguWKHCz7w89q6BLLDu3VHzbooJ+x9K5EqEg9fOx8M=;
        b=En/AB4WfGo3pxQzTf9JEOzDOH5l3+wpIOaRZNUtwt57YPdK6zeYNU5Wx5g7CLoTqTx
         Zs+/mzRzYSJIspXp+qsX4uONawrE7eiamRZcoAaEa9Axqk4LSDadu0y0MBabgC7E4UBF
         HwNovwMAAFoYxkN3zUvDae75LlvUTBkVlRDbXtRItJZFR63z/it3ao41RgVIajkJIfNv
         ZbkpoIlMMlrTValGZRmrgsYfPRB/tUxbrXJSgmuJA+kQXnmBM9PO3JrLS3ytSTUUsKix
         q6kuOoXrN/E1yeDtqeZylt3FT+bORUhACXT0QE+whv0crxcwExUXx3yL138i9G5QojcG
         Fz9w==
X-Gm-Message-State: ACgBeo1XA5fBYB4TflJ51Xj6hqMfyfxTinztMyAtQzZqy3PtQBlsfXtG
        WYMG4br2zOXss2hNwBG9ai4=
X-Google-Smtp-Source: AA6agR51Z+ds6I0M8yufiA5kSmLZU2RKP47ZMnLS09yHSfjWtCL9aMVHuotM8jobWxV0h43gw/6yEQ==
X-Received: by 2002:a5d:51d2:0:b0:226:cfa4:a998 with SMTP id n18-20020a5d51d2000000b00226cfa4a998mr8880175wrv.689.1661866529306;
        Tue, 30 Aug 2022 06:35:29 -0700 (PDT)
Received: from elende (elende.valinor.li. [2a01:4f9:6a:1c47::2])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c3b8500b003a319b67f64sm3752650wms.0.2022.08.30.06.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 06:35:28 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 30 Aug 2022 15:35:27 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     martin-eric.racine@iki.fi, 1017425@bugs.debian.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: Bug#1017425: [PATCH] x86/speculation: Avoid LFENCE in
 FILL_RETURN_BUFFER on CPUs that lack it
Message-ID: <Yw4SH2EuvnFJZHJs@lorien.valinor.li>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
 <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
 <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
 <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net>
 <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
 <Yw37wnE19bAIhhP2@hirez.programming.kicks-ass.net>
 <166062224255.2056.9595118849979455037.reportbug@pxeth.lan>
 <CAPZXPQfrCQi5y0yS0kXNYajb_YyRGBPj1hhJEYEWWUsJxa-EHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPZXPQfrCQi5y0yS0kXNYajb_YyRGBPj1hhJEYEWWUsJxa-EHw@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Martin,

On Tue, Aug 30, 2022 at 03:18:51PM +0300, Martin-??ric Racine wrote:
> On Tue, Aug 30, 2022 at 3:00 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Aug 30, 2022 at 02:42:04PM +0300, Martin-??ric Racine wrote:
> > > On Fri, Aug 19, 2022 at 3:15 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > On Fri, Aug 19, 2022 at 01:38:27PM +0200, Ben Hutchings wrote:
> > > >
> > > > > So that puts the whole __FILL_RETURN_BUFFER inside an alternative, and
> > > > > we can't have nested alternatives.  That's unfortunate.
> > > >
> > > > Well, both alternatives end with the LFENCE instruction, so I could pull
> > > > it out and do two consequtive ALTs, but unrolling the loop for i386 is
> > > > a better solution in that the sequence, while larger, removes the need
> > > > for the LFENCE.
> > >
> > > Have we reached a definitive conclusion on to how to fix this?
> >
> > https://git.kernel.org/tip/332924973725e8cdcc783c175f68cf7e162cb9e5
> 
> Thanks.
> 
> Ben: When can we expect an updated kernel to security-updates at Debian?

When the update is ready to go. Likely the update for the next point
release for bullseye will contain the fix for this issue.

Regards,
Salvatore
