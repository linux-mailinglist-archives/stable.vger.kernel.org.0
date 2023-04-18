Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB4A6E666B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjDRNzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjDRNzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:55:01 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98362698
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:54:59 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q5so15559594wmo.4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826098; x=1684418098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5SNUCcjykIdKKCiZFRF+vb2BpV3UFJNjVjypP4Hx4U=;
        b=lHrGbHBcqvJbq2sZEVQ14sAcgNmV6LbfIMvwDodaAo48mr6FBDSGsIUeRQu0OaGjc9
         ZHLPKBuNbXZKf+kX+rK5mBnL2Jk7rF0VI/6Ye2XEjCzX9wrSCyR0uvZ6nACwNC26gfsg
         yc1RfnO26ZHPGPP1BEa+sHL+DgFJgBwIq3LfTB505khBGOWbv7tkH+UZ0+FAPB558Qg1
         iEHB59kTPN/HwUs/hFx7D8zPe4vvCFjtglF3F8EkM+INLxWJwPLQNWzRi0ecnWtq5D8W
         kq77s5SqioGWi3zG81bMVLHR85K6ipQRVTHyiZx2321HDlOFmoB58al7ncsYjAaOcjiQ
         S3vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826098; x=1684418098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5SNUCcjykIdKKCiZFRF+vb2BpV3UFJNjVjypP4Hx4U=;
        b=EEyAQLQ5fjgqjlf6z11LJiNtRyhfVEorhTgQ5c0bD41juLCZUC7z0sIlqWCn8sBZTu
         RHPebOWSRgCP1J0lTU2aFa5Ep4M3IPmjqtfJlWui0r5xCq6Yp0H69dved0otfpGayCZ+
         Xxym++xVm19P1SH7698++Pi9nZASuiwjgCT4hVK6sJiGUIo4eWo1FRXdlD86EFiwx6e/
         lSj+puVnOc2eWHlLV/ktRzw5GkL1MoJDFjP2G6LJGeUtRk93l3T3m+gN2QzQxH8g7ooM
         MsCWF5iaJ7M6Gyw8K4fcp+RLhO1+hDIlbAS5cGGex79cOhBVwy0iFHF00ahABSYetQub
         zABg==
X-Gm-Message-State: AAQBX9fgX9IvWKgSMQozjvMdRL8mxFQns8h3ih7XLbmW43TyQbg5txG1
        vZVXulPMVViuF2/1wn2FnU3T/Q==
X-Google-Smtp-Source: AKy350b2Sxc1pVMGSJQM89vMl+h2c3JEy6nzn9kIxzspmqJ0ZMig/cKsmipYEIVA5HpJyVUl4+iDrw==
X-Received: by 2002:a7b:ce8c:0:b0:3f1:72ec:4015 with SMTP id q12-20020a7bce8c000000b003f172ec4015mr5448605wmj.13.1681826098444;
        Tue, 18 Apr 2023 06:54:58 -0700 (PDT)
Received: from airbuntu ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id r8-20020adfda48000000b002efacde3fc7sm13187764wrl.35.2023.04.18.06.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:54:57 -0700 (PDT)
Date:   Tue, 18 Apr 2023 14:54:56 +0100
From:   Qais Yousef <qyousef@layalina.io>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH RESEND 7/7] sched/fair: Fixes for capacity inversion
 detection
Message-ID: <20230418135456.mh43szfyqclagztj@airbuntu>
References: <20230318193302.3194615-1-qyousef@layalina.io>
 <20230318193302.3194615-8-qyousef@layalina.io>
 <2023041842-treachery-esophagus-7727@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2023041842-treachery-esophagus-7727@gregkh>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/18/23 12:30, Greg Kroah-Hartman wrote:
> On Sat, Mar 18, 2023 at 07:33:02PM +0000, Qais Yousef wrote:
> > commit da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.
> 
> As this is in 6.2, what about 6.1.y for this series?  We can't have
> people upgrading to a new kernel tree and have regressions, right?

Yes, my bad. I did check 6.1.y but missed that 3 patches didn't actually make
it there. I have cherry-picked them now and have a series ready to send.

> So can you please also make up a 6.1.y series of patches and then resend
> all of these (5.10.y, 5.15.y, and 6.1.y), and then we can properly queue
> them all up at the same time.

Okay will do this later today or tomorrow.

(Sorry I missed this response earlier).

Thanks

--
Qais Yousef
