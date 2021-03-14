Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9B33A298
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 05:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhCNEOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 23:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbhCNEOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 23:14:00 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88583C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:13:59 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id g8so6102906wmd.4
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightbitslabs-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=UDlj4/23/i4glcl15X6jS0Xc5V7K2kYqhUfsnXtlOSU=;
        b=Ln5zyEjAPj0N9U77LijmDIfIEW1TTuHpjsf4fdhtpoAwbvNMoM/PHFulIM6q0nOm8g
         i3LhsMcp82zoHpLB879S3i5k5C4ZI0a6bpKbJ7Ziw2Wu/ccwDZQqsTkEohQg8T0nrYqf
         UFFu7gmcduEFDgQzvOSG0zspjmTpV8ByaY/IFtrZccmlbWYiNMdCuXSSg/UWxtzsU3Sd
         LzG3hrRv+hcsK3bMphPbgHnQm15L8lyTatHm5M6CeazUsP0dS9nALLpJT5GrZFcmP0gl
         N6SRNyBe0qtvqOPh4YXHSie/1x91WZxcIGs36OC/SFtlRh4nyojkR8aHx8rwf4hOdFYU
         iWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=UDlj4/23/i4glcl15X6jS0Xc5V7K2kYqhUfsnXtlOSU=;
        b=bu3tz+KtXzQT48MteOBa8RekvzVIM1lOI4FPn6INIeSWGuKbhB38YwIDhcTXcmOrjw
         g6xJbu+U7DLfhLugSlswxeOcYw7Od+tGt5Jo9PlyKOncTNC7xDhiyMgU0qcaMsxBVbDF
         i1WImg3naAMatZTaX8g4ul3Y2hB6LZyc+P+kohi6U7RAZnF/6Gjur8L0DYTzsNtnBnXh
         7UwG7/9SevV0TlVlQGVtyMxJC67FOEIbveg5xw7scNQBEZSiXXLqNePedlhK9TZvtAqa
         V1gsmjNs8DAni0YusoARH+P9NNjBX/awl64LYUFg0VJ7jUNB9DoVEuUzfbZHu8ZBl/mT
         8YBg==
X-Gm-Message-State: AOAM531XFqiHC4DFxvQegD63gmaB/qcC90tqNcfYKk4W6MswTAcmW7Bg
        tzF6sl+CK1Oi97RfGkG7FI96kHmYcukbiGLL+IQ/hmYuB9O+enuPPZPBPJr57PV1nExi5EA7Z5Z
        gWXXd9ZjTEpShIDOlfg==
X-Google-Smtp-Source: ABdhPJwDVdRtegftWyPipJfoLcTWI0aznkGz7dpugkGWOUu4NtmV5xKkUKcmYnHYudqg4tRzmdS26g==
X-Received: by 2002:a1c:7c14:: with SMTP id x20mr19205790wmc.17.1615695238112;
        Sat, 13 Mar 2021 20:13:58 -0800 (PST)
Received: from anton-latitude..lbits ([98.42.3.175])
        by smtp.googlemail.com with ESMTPSA id a14sm15227225wrg.84.2021.03.13.20.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 20:13:57 -0800 (PST)
From:   Anton Eidelman <anton@lightbitslabs.com>
To:     stable@vger.kernel.org
Cc:     kbusch@kernel.org, sagi@grimberg.me, hch@lst.de
Subject: nvme: ns_head vs namespace mismatch fixes
Date:   Sat, 13 Mar 2021 20:13:18 -0800
Message-Id: <20210314041320.1358030-1-anton@lightbitslabs.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please, apply the following two upstream commits (attached)
(in this order):
    d567572906d9 nvme: unlink head after removing last namespace
    ac262508daa8 nvme: release namespace head reference on error

TO: v5.4, v5.5, v5.6, v5.7
These commits are present in v5.8
and apply cleanly to the above.

Reason:
These fix a potential crash or malfunction
when an nvme namespace is deleted
and then a new namespace with the same nsid is created
before the old ns_head for this nsid is gone.

The first commit prevents the new namespace
from being matched by nvme_init_ns_head()
with the old ns_head causing ID mismatch
and consequently a failure to initialize the new namespace.

The second commit prevents ns_head refcount imbalance
in case nvme_init_ns_head() detects ID mismatch,
and consequently a crash later.

-- 


*Lightbits Labs**
*Lead the cloud-native data center
transformation by 
delivering *scalable *and *efficient *software
defined storage that is 
*easy *to consume.



*This message is sent in confidence for the addressee 
only.  It
may contain legally privileged information. The contents are not 
to be
disclosed to anyone other than the addressee. Unauthorized recipients 
are
requested to preserve this confidentiality, advise the sender 
immediately of
any error in transmission and delete the email from their 
systems.*

