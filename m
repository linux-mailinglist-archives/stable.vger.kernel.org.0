Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3907E49652
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 02:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfFRAfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 20:35:46 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:33579 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRAfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 20:35:46 -0400
Received: by mail-wr1-f48.google.com with SMTP id n9so11975086wru.0
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 17:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K8Xm2K5vk8AxjUINR6AyvRhMPx8Em7Y1VtxIQmLSSVk=;
        b=TJFmZbT2/FlQHPvuvS3cDdrWd0Z2qcdHdzignqM025jS+jXCfBfVn4JbolA2rDVGIW
         1BFDwdbDjcDQBd/4VE23wCG0OQsBKygnexdI1RHWUr3EfN3Vk+4rnQFxT5mkSufdeyCE
         gWiTEYci2LQLeOrIbt5oGepyUcWbTkCIWBBXMzWEKwNywHlA1Jt1lPnKxP2MHOC7CSSC
         jetTCf1lLhd4SXsV2e3EZnVqpWm5JyOkIqX4jo5JMS+9d3ZF0Zku2SJq8c3l3TwWFngq
         fu+HSJZXp1hx6D/ojKMPK/L2Td5wolESNeJ7PIV5cAoqI+O+BygIgDuNBuofNt4tzIj0
         UmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K8Xm2K5vk8AxjUINR6AyvRhMPx8Em7Y1VtxIQmLSSVk=;
        b=TgXbYagRAXM/gQCmNU7GaHd2k/Yn64YdmP5vtJAuESTjEFMnVoVmOkEaQgK8xehAn9
         +luftMtCpcPNIGz7T26Dar6h7ZWqxZbQGlzTl26/4/A2cXABxRJsVH2B9ZMFQSv2JPfw
         lNLKYvyBkGATPurX2J0pXEM5iGB622lHoZKb3q+wrbkOMsEFra0eqvijsAvC8dpwAtEt
         So3w9xtX4gWhXiQABAlBIvuDPpqW0wq9g+VSGFvfs0xgIrsFR1FejcJaf6a99VBAqCZ1
         pEyDS311WwWWQkyg6pw8yKUsgNSpZEhYg/iHQ91/eMDy5KFwMzjTHIQtURMAh71DRWjh
         yQvQ==
X-Gm-Message-State: APjAAAXXaJgHIinHa3mDNfzS3evWYgXzRPh8jfLwAv+AOViS6KdbPYzf
        QYA5fCo8/GQ0bwGvGvxSVKB98n3ad6DGaw==
X-Google-Smtp-Source: APXvYqzLSiAyzxOO5RtkFelwwtY1zyhbFBuGF8m6+U63+znKXDG1ImrEDn/09O7XXMMlX8D4xkDrsQ==
X-Received: by 2002:adf:eb4e:: with SMTP id u14mr31731608wrn.168.1560818144303;
        Mon, 17 Jun 2019 17:35:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm14626462wrc.9.2019.06.17.17.35.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 17:35:43 -0700 (PDT)
Message-ID: <5d0831df.1c69fb81.a0bf6.eea4@mx.google.com>
Date:   Mon, 17 Jun 2019 17:35:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.11
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 55 boots: 0 failed, 55 passed (v5.1.11)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 55 boots: 0 failed, 55 passed (v5.1.11)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.11/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.11/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.11
Git Commit: 17bb763e7eaf2093a2832fd1d1a80281fb0e5ced
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 31 unique boards, 15 SoC families, 9 builds out of 209

---
For more info write to <info@kernelci.org>
