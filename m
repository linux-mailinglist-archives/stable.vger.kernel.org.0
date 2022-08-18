Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B003B5987C4
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 17:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343800AbiHRPsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343803AbiHRPsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 11:48:53 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2199240A2
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 08:48:52 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q19so1895382pfg.8
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 08:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=w6M+FZJJ529vb411UeOf1PfHGJuystXwWwsN/lXPQtE=;
        b=Udpcf6WhVCKSO6CCB5Al6hFLQuP0MS00JNK1tDth+LmtB9UU6RMGcnLFHOJv0Fybgw
         S23Rgca2ss5H4e+cl3zZEwW+y0HHjyY9+3/DohzadykEeluLL3uBlrIc2cDvEQpEK1i4
         lnOpf1PI0TnMrQjW3fAY4aEIMEdqnuev71sYHjImfqQyxLFKge2gYGjAWVOWoKOD4sjR
         je/C8HNym8Co3vT7BWNs6UcLN37hyUJEa/ARm/CNVUHO4DXC2aS6+Z2mDtff4BSNoJY5
         FUiS5M11y13LGQI4ektSY2NVzlv3Lhll9onjaIN2aO+4snoqzF0FQA3+UR1Gwt7gAs11
         cgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=w6M+FZJJ529vb411UeOf1PfHGJuystXwWwsN/lXPQtE=;
        b=TWtGeii7Fr9Y4mZXPEsH0iMbMCQleMuL1dXzP49VKC/Gbs0EMYcvH1g2iE65vjUCmy
         /tVm/hZETSluhcHy5NU/OdE2N+fKseZqcJtp70tU/aiKx0lgDwSqzd5WJ/1uRg8idA48
         JZnZWs6OV/teFvsntSLX9QHIkHIvHRKLaS7L/0PokH2nKD3wfUO3MqTC+oy9FCjXpUYW
         yA7Yez/lVn/eKAl5pYpdlldJzyJEMj4fjf/TWqD2fhLn6tjmAuaN+WnAlzf6Y27dSHZY
         BrcicgSTiZ+P81YPK9O55BX65nD1XOGhPOfZw3yazMXpr5Ztyt3CCRCu9izCKwPaj+Rk
         CHsg==
X-Gm-Message-State: ACgBeo23/laMafx7ahhsnaEZMdOZlWcz4H+ZEeN47DWB/xU7+3/zFhfu
        51FlzQWzzKBcJV5/2mg1ZJpAdw==
X-Google-Smtp-Source: AA6agR6wDXffZjaPdFflL1D/Q7WVISVKrEaMuiFY0z4v/MsPFMyeiR3/5GUxCCUakJJd3G0SNWvwJw==
X-Received: by 2002:a05:6a00:1343:b0:52e:8174:fc37 with SMTP id k3-20020a056a00134300b0052e8174fc37mr3536471pfu.32.1660837731931;
        Thu, 18 Aug 2022 08:48:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v31-20020a63481f000000b004277f43b736sm1437620pga.92.2022.08.18.08.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:48:50 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:48:46 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Christian Brauner <brauner@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Suren Baghdasaryan <surenb@google.com>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] binder: fix UAF of ref->proc caused by race condition
Message-ID: <Yv5fXiSkFEgvMrvl@google.com>
References: <20220801182511.3371447-1-cmllamas@google.com>
 <Yul9sEAtM+4aGbEg@google.com>
 <Yuoj1GVrgtflsYYZ@kroah.com>
 <Yv1mAu9Ndk1SoUHr@google.com>
 <Yv3NaRWWd9UPWEUq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv3NaRWWd9UPWEUq@kroah.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 07:26:01AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 17, 2022 at 10:04:50PM +0000, Carlos Llamas wrote:
> > On Wed, Aug 03, 2022 at 09:29:24AM +0200, Greg Kroah-Hartman wrote:
> > > 
> > > Thanks, I'll add this when I queue it up after 5.20-rc1 is out.
> > > 
> > > greg k-h
> > 
> > Hi Greg,
> > 
> > I think this might have fallen through the cracks, I can't find it in
> > char-misc or linux-next trees.
> 
> -rc1 only came out a few days ago, and I have a lot to catch up on:
> 	$ mdfrm -c ~/mail/todo/
> 	1770 messages in /home/gregkh/mail/todo/
> 
> Please give me a chance...
> 
> thanks,
> 
> greg k-h

Oh my bad, I got mixed up with 5.20-rc1 and 6.0-rc1. Please disregard my
previous email.
