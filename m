Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFFEF822A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 22:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKVV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 16:21:58 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38677 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKKVV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 16:21:58 -0500
Received: by mail-wr1-f41.google.com with SMTP id i12so9325083wro.5
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 13:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0EQ/kDaT7e/HbEicjoVL92ybwPZT9z79jly2lni/AtI=;
        b=aBWZXNgqqYk6R9w8ZMXLVbxu0V1E18gasxGaj5kkMlcaI8b2ewFe47jhzJz5oCf4G7
         RfMFBRPGgd1/2sNlYJhSb2dHauDqsGh0l1IQJ44DW2c9DA9864N01YDZZ+7jJciYjdtl
         JIj3SOBMZwGVgfEpnhVzR6+PQI+vwUM+yAi54seuJdn6z4YoJQSz+wsicEWrI37RPEDL
         utaZ1rELDB0QYlEm/GMqX8i2TY1Amb48hdv36oHhmffbs+YNV6VpsqITK8uEhuMBHq8b
         bfMxs+VyoGOKZqEm0JpehqzrUq5qrJDKIFa1RIYA+hCZ9d0fZSh4okWzKXkx1CZrg+bR
         fN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0EQ/kDaT7e/HbEicjoVL92ybwPZT9z79jly2lni/AtI=;
        b=j6JbXSLofF+Hj0GNwzeRi6Eem1mqv+5RljnR43S2pKGnRmGOU1HfNUFzi2JDiAkdjR
         jtbJMB8dodBN6gG0HlkRPTzBMRFzg/CYl05T1nV61a6rARkhl36NFkjMhsmlr6fqSp50
         c54DcbKfyrNb1Cq8QV7UdH+XgBdmWThV4rUSBN+uIfyTxg6Fk+m61SIpT5KSHzkigg6Z
         PGqOu0qcwIzIIPGebGBptF1FQXj4E3kQlX1Q03kLarl9jtaz/2I10+Jr0zP5feBJoknb
         DFVooY5cZGebkDsJGsF4pCP4fYXIWS0OiTcBToHrSNVUOgdqk0tkuPZ3aBfz0gxxBR4/
         TiAg==
X-Gm-Message-State: APjAAAXsQ/sy1UtFmDZeMTnPfAbV0/VippvYk3yALBCvaCbKcYNVCArC
        fyz2yJiDfNlmw2XbL8d5ytr/JGBZfFg2EQ==
X-Google-Smtp-Source: APXvYqyyP5uIPIlJKZ9sYj8nDz/CW1fG5InKY8RiFNCgV6xerB+Cz3+iIigRN22Zpobq8VLEOxDVvA==
X-Received: by 2002:adf:e881:: with SMTP id d1mr7790419wrm.296.1573507314495;
        Mon, 11 Nov 2019 13:21:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y9sm715208wma.3.2019.11.11.13.21.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 13:21:53 -0800 (PST)
Message-ID: <5dc9d0f1.1c69fb81.fbd8.3c82@mx.google.com>
Date:   Mon, 11 Nov 2019 13:21:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10-91-gac5e66a17918
Subject: stable-rc/linux-5.3.y boot: 73 boots: 0 failed,
 73 passed (v5.3.10-91-gac5e66a17918)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 73 boots: 0 failed, 73 passed (v5.3.10-91-gac5e=
66a17918)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.10-91-gac5e66a17918/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.10-91-gac5e66a17918/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.10-91-gac5e66a17918
Git Commit: ac5e66a17918615c051027b05651c38bbc311545
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 14 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
