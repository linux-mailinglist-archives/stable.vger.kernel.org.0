Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8A4BF75C
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiBVLkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 06:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiBVLkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 06:40:24 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1521A13700B;
        Tue, 22 Feb 2022 03:39:59 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l2-20020a7bc342000000b0037fa585de26so823233wmj.1;
        Tue, 22 Feb 2022 03:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=zncUP4k0qWTkrruw/2Qwtl328+sz3ixjRaMsIKFNcuk=;
        b=J0YrKwOpbUfqraOO9E41qOPkgPyLuArO/jKiPXyL/a+y6mYGCec4wocwAYxIqjgSEi
         EC411gJCwZDRNbtM8yXldOqf/yIK3xB2NQiJnScFJwbiFj7qMQIz8DhgGSaykFzfnG4i
         CP2itFJmT73SO/ivn4phrMBjFoeuW69P6R4tsVxTfWTdDK9Y6aKDxeaalgOQtDT1sOoV
         PV3dqkpWp6WYCWCat1SOxD82QrjAAmlzp3FqV/GubPC6cuqBJD2pr1PHX9uiC+24Iw3C
         nEvwtIeCLw1R5Rzg8Kw5Faz9fNmYgLSgDAsWC9Ze2F6SSZfn2d9UAaOfMyu4b2xt/XGY
         PW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=zncUP4k0qWTkrruw/2Qwtl328+sz3ixjRaMsIKFNcuk=;
        b=WajVr0KgUeXZWRX9wQjFZDQvCSlGrmIXjS0z3nDycxcdbAErk46W0lwO3Sk62NzWxU
         q13bm6jbFnxRaxQwzYnZ5KI/oWHYFEE57jc+TAz1beXdPsQZuQBmaLhMrKGTJjszbP2d
         By1TcHAzu576qM71DG7PSjPYCMp5Fp2XArEf5YY7UKQ7qt6fZEx33lmH6SrLxLFmVjy9
         J4WNCT4o/FUCEmn4xQSB7bFIDE0N8syeBPJgrZwWT4gHm3fMQ6eGYmZkPXpv3SO5adBk
         P28f4anb76lAd8ZO2tFQSX14zz/FLpjhrQBMpuYXEuDtLzJwUjsLKXjeNo2/uQrfOS+N
         z7hw==
X-Gm-Message-State: AOAM5304HfYsZ3h2ClzcFir50EMmw0OQhfxKRqLukIDxLhSMfZxXJnxl
        I4v9FyRyoIyr/brhtQX8eOc=
X-Google-Smtp-Source: ABdhPJwf5XXk+nm1c1aQoW5W3sS0bpeUEvQEKw0jMqDwHDSUwhUk9wLVBFHdsPdibESz1etUflZwpg==
X-Received: by 2002:a05:600c:33a7:b0:380:dc3b:a315 with SMTP id o39-20020a05600c33a700b00380dc3ba315mr1563211wmp.135.1645529997722;
        Tue, 22 Feb 2022 03:39:57 -0800 (PST)
Received: from MACBOOKPROF612.localdomain ([102.165.192.234])
        by smtp.gmail.com with ESMTPSA id d29sm20265237wra.63.2022.02.22.03.39.46
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 22 Feb 2022 03:39:51 -0800 (PST)
Message-ID: <6214cb87.1c69fb81.403ca.725a@mx.google.com>
From:   Scott Godfrey <markmillercom322@gmail.com>
X-Google-Original-From: Scott Godfrey
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: CONGRATULATION!!!!
To:     Recipients <Scott@vger.kernel.org>
Date:   Tue, 22 Feb 2022 13:39:44 +0200
Reply-To: scottgodfrey.net@gmail.com
X-Antivirus: AVG (VPS 220222-0, 2/22/2022), Outbound message
X-Antivirus-Status: Clean
X-Spam-Status: No, score=4.6 required=5.0 tests=ADVANCE_FEE_2_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,T_SCC_BODY_TEXT_LINE,
        XFER_LOTSA_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Name is Scott Godfrey. I wish to inform you that The sum of $2,500,000(M=
illion)has been donated to you.I
won a fortune of $699.8 Million in the Million Dollars Power-Ball Jackpot L=
ottery,2021.And I am
donating part of it to five lucky people and five Charity
organization. Your email came out victorious. Please contact via email: sco=
ttgodfrey.net@gmail.com. For more information about your claims. Thanks.


-- 
This email has been checked for viruses by AVG.
https://www.avg.com

