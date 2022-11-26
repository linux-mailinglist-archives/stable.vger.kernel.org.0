Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B810639605
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 14:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKZNFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 08:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKZNFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 08:05:51 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9148918346
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 05:05:50 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id e15so219237ljl.7
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 05:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wlb4SYlCkKFrC3vDbrNKcnlsbFr9aWDknzVh2AdUFE=;
        b=VEMeEMf9AJ1us+8pITQbnWolzlfHoA1PMSl3vCkgducpAVonGc71jNoPOKmBtuYe8K
         lMSWoD2+ZsxoUa9YHj3j3e1I8Z1349IA0hHCofudHlBjjn78UfINrmqtuyo15PczBR6c
         Emr6VE0EI2n9zpbiFa0jJuEDphRudHzT4ufRCTQFabTby7smlNFoS/3UdcU2KsYrfeKE
         209fgTnnylFCSLIbM7M+zWMtCZd65BRpUIU/CzcBekIN93WNWlBHJIFs98J34TWBorko
         NXCWMCpboyLy0NeJLjIAqRCnCYm8G4ST6HM5dJTmH6SPSgJYhPxNeA/nGrweEsOUBMuI
         j25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wlb4SYlCkKFrC3vDbrNKcnlsbFr9aWDknzVh2AdUFE=;
        b=0iehHEVM5GRNfIYF8ulC4yD+wEOvblF8sYw5fQpB8V4uFcyjX2ga5VpDO8y89b1qnt
         oY3mUCpX34N9asrOpDaTxZkCbH+NnkKdQUsP7P+ulCzVf7bMxffanVy+sLH9nchm0khg
         6jKSRbmhzweWUCBqvNIN7Ql21npiH95gLuiq/IpaPjuCyg69C25imOPArXDKWWp4DdmI
         GHlaWMq2Bil2bawtXbhPJj6tZ6OPtDaAxRn6cb9b+mJj0nRFNI7f6ggHi/R21J7GF1Ld
         jo5cQ6jYDPK6BSuRwRUBQ+pFN1hWSovwTK7EbQI6D6OoLnC3sJvkzU007e2/eKFePCN+
         Wx4Q==
X-Gm-Message-State: ANoB5pk3+Y1hWm5LKVBlYxnXZo7c/g2+h4SzPj1Gkt+vecDpsG1ViScR
        2jPqU1kMjrEaVmEb9321l7A/gq4+JugeGv3gaT8=
X-Google-Smtp-Source: AA0mqf4e4IXYmJPIur9c5lbLpLrTFRmbvz+RSZrVabf/2ADS4VNp9VsWOKmW2yeXWRUhI1HX+qCeS9/AVlQhVyssOaQ=
X-Received: by 2002:a2e:b631:0:b0:277:890a:f1cc with SMTP id
 s17-20020a2eb631000000b00277890af1ccmr13992106ljn.395.1669467948697; Sat, 26
 Nov 2022 05:05:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:9256:0:0:0:0:0 with HTTP; Sat, 26 Nov 2022 05:05:48
 -0800 (PST)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <info.ninacoulibaly11@gmail.com>
Date:   Sat, 26 Nov 2022 13:05:48 +0000
Message-ID: <CAKjR=UTHF+jRMYxAgVRJA9mORDgV5HT9y8+B0FpUtW9qhb=rTA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
