Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDCE4DDA24
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 14:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiCRNJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 09:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiCRNJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 09:09:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92B42986D2;
        Fri, 18 Mar 2022 06:07:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id m30so1843350wrb.1;
        Fri, 18 Mar 2022 06:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lHJUxhr0q/fLLgAgJ1hsxiSujF7pe5kTN3TD9F1pmy0=;
        b=eVU8yYe+T+Yz5OFxsyacazuGOIeIzeIAWBxW+yz4AixAnUQl4NG8dtbNDDUoQcuW5A
         mArinQxBe505cQ1LSfe3u7HzhddDxGdis20BSGKJIPCTWJSLS1+uG9zI1Ut8w7NF3fSO
         piOJ5adSJ4D4oMuHbBYSBOa0zwvhC+pSct8SUOCDLynLEXB4nNZwyWGrNGubG7NAPFTx
         avvzgcn2Qzkq6MWonzFHp3QoCvzWkuxbGIh1VH5uF9jb5mwqBkf7sCD2vsA/SO2jGMvO
         kd2Ld2EkMx9doZKKhItEyB0bBA2CP5I9fFubIZ6+Sw9tulMP89vvqoBxlAQYzl81dvPE
         eGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lHJUxhr0q/fLLgAgJ1hsxiSujF7pe5kTN3TD9F1pmy0=;
        b=jIk9NGkrGN/AVmrgt15PTLq8eCe5NhAaoMl0X8PUES0e4skfu4rJxFCC9fIRL9MXUo
         UES8pwsWNmKUfkIlKQo3o+QXlCj8w/wV9fsb4BtI0/PiZOM0cI3bcLpoNjD7P9isZlRf
         L2vgmBq7cxbCq2Y8NaG+QDOKjoSED3m8dQNAig4ANGEaG4k56gOOWaSribc6oi1IGl6u
         xE22ISfipfh775h8oZpKZHW+cUeLDrmAz91XbaIPvnNxeLJPD7b+XEnET5LBE/vw5F3p
         JFchEoOPbbSc2uiy2mo4Osz6fRvQ6gALalorNlpOg7vcZw01NwpoQ4ZSFLpl1+ylZ/1H
         18tQ==
X-Gm-Message-State: AOAM530sREK30JE8bC66NS6GQsq58BmSPp7nzrmeBwbCMpsg/5EEEMbi
        Eyt2ay6dcfzAg0QXtpiFn7k=
X-Google-Smtp-Source: ABdhPJzWrx+EvHGimSG8O/nEhVa0gGiVeJppmvHNj2YmE8uqF1T4tMrmEhErVyph5Md8Np0fx3vWXQ==
X-Received: by 2002:a5d:47a3:0:b0:203:8cc3:3647 with SMTP id 3-20020a5d47a3000000b002038cc33647mr8161918wrb.321.1647608864120;
        Fri, 18 Mar 2022 06:07:44 -0700 (PDT)
Received: from elementary ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm5927702wrp.108.2022.03.18.06.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:07:43 -0700 (PDT)
Date:   Fri, 18 Mar 2022 14:07:40 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-input@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Right touchpad button disabled on Dell 7750
Message-ID: <20220318130740.GA33535@elementary>
References: <s5htubv32s8.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htubv32s8.wl-tiwai@suse.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Takashi,

Thanks for reporting the regression here.

On Fri, Mar 18, 2022 at 12:42:31PM +0100, Takashi Iwai wrote:
> Hi,
> 
> we received a bug report about the regression of the touchpad on Dell
> 7750 laptop, the right touchpad button is disabled on recent kernels:
>   https://bugzilla.suse.com/show_bug.cgi?id=1197243
> 
> Note that it's a physical button, not a virtual clickpad button.
> 
> The regression seems introduced by the upstream commit
> 37ef4c19b4c659926ce65a7ac709ceaefb211c40 ("Input: clear
> BTN_RIGHT/MIDDLE on buttonpads") that was backported to stable 5.16.x
> kernel.
> 
> The device is managed by hid-multitouch driver, and the further
> investigation revealed that it's rather an incorrectly recognized
> buttonpad property; namely, ID_DG_BUTTONTYPE reports it being 0 =
> clickable touchpad although it's not.  I built a test kernel to ignore
> this check and it was confirmed to make the right button working again
> by the reporter.
> 
> Is this check really correct in general?  Or do we need some
> device-specific quirk?

A couple of days ago another user with the same laptop (Dell Precision
7550 or 7750) emailed me to report the issue and I sent him a patch for
testing.

I he confirms that the patch works, I'll send it to the mailing list.

I believe that your analysis of the regression is correct and I think
that we'd need to add a quirk for the device.

In case you want to have a look to the patch, I added it to this
libinput [1] report.

Thanks,
Jose

[1] https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/726#note_1303623
