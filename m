Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211005BFD85
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIUMKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiIUMKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:10:47 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F379413E
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 05:10:46 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-127dca21a7dso8668434fac.12
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 05:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=1gTGY1DNE2nKZuY8UkgCxRSEIrx8eylTnxV11kGpsRs=;
        b=floDUQ01qFuiHGXP9iPdIEyHicTfzU7o0xr+XdyEIHEPICeD3yGFDSUndr2/6NZIQS
         tkP2l4gN3/XmGnidVzz2ZcsRIHCvhZHiOX9fcnAFX7PtEVhk8yu7GCNUlY1t2hOAqQOh
         vKJNheCwKTTa1EMkfGLscjSbFl/f8M/qqSYYhMFrmpHE8hCIppsCsolhje7mjPP2tAqe
         T9Muw7rXQ3937m64JA0qbixYDUKYNvlZOwU13cxqJfDhSmlMOjhrAEvnKTSrUWZgz4sf
         i/qYbYC4eSreY7Jn+M/QkaER8q5oF5aq9QOFT3+gQdbwL76GDLOsFMu9zkd/JFhKRV+C
         v1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1gTGY1DNE2nKZuY8UkgCxRSEIrx8eylTnxV11kGpsRs=;
        b=gjk6l82TcMtSSMLFgpcLGUeH2aeB7EfaeeqcUS2YLN+p7Id4t1a36hE1fqiFvqpzbt
         DX0VIP7ue0U2CEr5XOg1Hj799wZohMitsjcDlg6NFS80OcSi68YNCadiH56waoRM60dB
         gh3Vgn9l72ueUEQfHHN2wAmGnkulEuoIGxY2US+k3uEVTz5duCqavSHoPTsQTeaPWF7e
         lHAhaD/f830HXyT7oR/KmmKxM1DJrR3TmE7LN9FNWHdviegfxzofFjH9gqzpAkj2fRUn
         nCZVBP3w4PWO8Vk7Er7bCQZD5QMCAi0knXUlRzhQ0xcqso/4TyWzIpswnCcBLIFHANmm
         HO1g==
X-Gm-Message-State: ACrzQf1dYuFbRDAoxYi4jbzLora1ZxnEsH0VrZ9qpE4IU70e8BPW5yoM
        t01L/Te1/hktFDofjrsHsbanUbfxTwbdlZkunlo=
X-Google-Smtp-Source: AMsMyM4fS16fAf+5afi0abZwRGMU099AMWzcL0bxM4k7LtqVMhZIWP1ddclEu6XSraNdMvVtkgUSxMg3tXHdkVSutic=
X-Received: by 2002:a05:6870:c0c3:b0:127:f467:b2b0 with SMTP id
 e3-20020a056870c0c300b00127f467b2b0mr4822579oad.110.1663762246069; Wed, 21
 Sep 2022 05:10:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: helenjethro1@gmail.com
Sender: swarankard@gmail.com
Received: by 2002:a05:6358:1983:b0:c8:1f38:9a63 with HTTP; Wed, 21 Sep 2022
 05:10:45 -0700 (PDT)
From:   "Mrs. Helen Jethro" <helenjethro1@gmail.com>
Date:   Wed, 21 Sep 2022 05:10:45 -0700
X-Google-Sender-Auth: mjPs3nWOmhb9AdY9qU8uXkjhtZs
Message-ID: <CABugrTX0bvQMPXDz01RPvD5V3Bz+MLb2fep-XPMdzwyom79m4A@mail.gmail.com>
Subject: Have you received my previous email massage?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

Have you received my first mail? If not please let me know for urgent
matters. I am waiting to hear from you soon.

Thanks very much,
Mrs. Helen Jethro.
