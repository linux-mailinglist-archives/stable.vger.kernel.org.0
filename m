Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197F26120D4
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 08:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJ2G7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 02:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJ2G7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 02:59:12 -0400
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27993816A2
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 23:59:11 -0700 (PDT)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id B70066013E
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 15:59:09 +0900 (JST)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 290346013C
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 15:59:09 +0900 (JST)
Received: by mail-pl1-f200.google.com with SMTP id q10-20020a170902f34a00b00186c5448b01so4603934ple.4
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 23:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6F/e3an+HkL6s8uZYrMNfU7hm7ZeC4VHKbQWbFreALk=;
        b=ptynBrOwGorB1wclKBZmt2zqOXJ6GFbi60NIuNu8mR+Z1jOFIb+QiwBgra7+AyVXf9
         8yx9SCVImW6sq8wsa1hKGQi43V7My96LphLYtVw+xT97j8xcgZy7da3HEnq0mBGe6DIz
         Z3Zm4iq/v8pfgbTeaLAWsy3hVJOw+21wOkICjqAIDMnGvoHtqKA1LNYAxEh46SabM9sZ
         hdh+v2Y6xxks1Rx2t+WwKe2R0BRE3mMf7WjdISZXdT8U/C0WLNBfk3sZ8/SXwma6Xjew
         jmgC2chmGGFyoAAbHthxuKlfuFwa0MSxgtn+vsDzwkyxQJZp/pPIFRMGvufChmN86Ln1
         e7iw==
X-Gm-Message-State: ACrzQf1lzquNtysws8aIzK4reqnWxtw2PIrVharppfaNtHFeNDwEa57s
        Z2y1TEd3noj+vypPiKcVGUGm78RPP0RqBxyH10qGT9EZnvapqA0VRYiBnpLSU3cPramUk+eAr4H
        WVoh0jiu/3kMi5jQnfnrF
X-Received: by 2002:a17:90a:ce89:b0:213:167c:81e1 with SMTP id g9-20020a17090ace8900b00213167c81e1mr20705684pju.38.1667026748215;
        Fri, 28 Oct 2022 23:59:08 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7YaSV9vrd5tee16XR/CS30ja/JOgXjwptpxXCf0g5s4Z5wS7VTmgf5FDPF3+eoOR1Q9ZBC4A==
X-Received: by 2002:a17:90a:ce89:b0:213:167c:81e1 with SMTP id g9-20020a17090ace8900b00213167c81e1mr20705662pju.38.1667026747927;
        Fri, 28 Oct 2022 23:59:07 -0700 (PDT)
Received: from pc-zest.atmarktech (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902cece00b00186b06963f9sm558705plg.180.2022.10.28.23.59.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Oct 2022 23:59:07 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1oofo9-008u42-28;
        Sat, 29 Oct 2022 15:59:05 +0900
Date:   Sat, 29 Oct 2022 15:58:55 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
Subject: Re: [PATCH 5.10 v2 1/2] serial: core: move RS485 configuration tasks
 from drivers into core
Message-ID: <Y1zPL0Y6bmqvvhMw@atmark-techno.com>
References: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
 <Y1lmM7Qu1yscuaIU@kroah.com>
 <Y1nPFe6IaRI7j6fE@atmark-techno.com>
 <4ff347e8-1ef4-e006-01db-3d420213f6e3@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ff347e8-1ef4-e006-01db-3d420213f6e3@gmx.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lino Sanfilippo wrote on Fri, Oct 28, 2022 at 10:06:51AM +0200:
> > I'd really appreciate if Lino could take a look and confirm we didn't
> > botch this too much -- we've tested the 5.10 version and it looks ok,
> > but this is different enough from the original patch to warrant a check
> > from the author.
>
> However the part Lukas authored (patch 2) seems to be the one that has been adjusted
> a lot, so maybe you rather/also want to have his ack?

Gah, sorry -- I'm juggling with too many things at once here and got the
two patches mixed up.

Yes, I meant Lukas here for patch 2/2, sorry. Promoted him to To.
And thank you Lino for having a look and pointing it out!

-- 
Dominique


