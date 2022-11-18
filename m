Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C40262F9DD
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 17:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbiKRQCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 11:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiKRQCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 11:02:46 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C19062C3
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 08:02:44 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id i2so5162955vsc.1
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 08:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjZxsnocoR7rZICxp2BCTK3Yaa2EAZ5imxDMKJ71dlo=;
        b=QU4rnIKYAGi91I2GkJNnRSb+X3TwHdQWimMe8i8hNj2+4y3LKaSsM1Vs/4R9lcZ86i
         wTjSPh90bM39zsi30muxo4jwxttDEQZKjp1yq2P50adIs/B6tlCUSlbmVLYpN5LNRbsx
         LaE8zqzDHO5BxBbsuHr/YwXaMKXZZuJF49Tzt2sb1RR6JnPPDJ4JjBjfbuDxJaXLYtku
         w1LFiOp9iwlGnHceY0rp/0GlGdbInJ3cXT/xtTP/JdYkcvt48GHEZVyMTRt0reIV5XHh
         9BVzNv046MMorwjRy/uZi5Ovc0OywHXdywLR2ZXof9Fc+idif89ibR8lznj8GpDxZm34
         naZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TjZxsnocoR7rZICxp2BCTK3Yaa2EAZ5imxDMKJ71dlo=;
        b=D0D6KLpnz5JbFMKe/RzvsrF4TGSdRgGEpD0Jaq1smQ4qZqRMPB0xmE8+HAMMvdSNfz
         au0Ro0Flk0YNdBeLTJatKHYWFh3Q9QXE0Xm5thPAVgIzcVB8NOMHln45zKoY7kCdVPVh
         6ZvIc9o3LR3B80TbSJ+J4m6JNmTCm+1xYBODl/yQbHG22klkJWyshGlLE6c+MFMoP5po
         jwEX8+sjIzLI76AQQJh/hv3sJalyzXpuGkpuRlGZ2NV2m1RucTD0ys9/kOBbOr3f845R
         +tLQ56NHvyZM02Dj1EEgEPdLUwxJlLPzjV/Q3Y9P5WzYvIfTT6Op1xQt57oS15xZFAPL
         A2BQ==
X-Gm-Message-State: ANoB5pmye7/gMHoobcXE22nNyrkfnOlSX2vR7m3ESBpTrb84sv9btSOc
        VeKNxsLWQpeAkRGINncFE2EaPa+AAwd7LBMM6T8=
X-Google-Smtp-Source: AA0mqf7n2CDq5Ie5YQ+2JbPpECxCTytBO9lIvmf9GaxTMi4jVKlPmt+qCGrFC+y10OS3TwchGjfCY1bxgaaZ8SbxtoI=
X-Received: by 2002:a05:6102:1009:b0:3aa:13b1:86e6 with SMTP id
 q9-20020a056102100900b003aa13b186e6mr4890436vsp.36.1668787363519; Fri, 18 Nov
 2022 08:02:43 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:596c:0:b0:411:35ed:4747 with HTTP; Fri, 18 Nov 2022
 08:02:43 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   Woo Nam <woonam115@gmail.com>
Date:   Fri, 18 Nov 2022 08:02:43 -0800
Message-ID: <CAGdtzSb9uKjZDXRfSvyz9-VyShPZmmOi0ttgYBesN2YWR1cc=g@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5008]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [woonam115[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [woonam115[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,,
We are privileged and delighted to reach you via email" And we are
urgently waiting to hear from you. and again your number is not
connecting.

Thanks,
Woo Nam
