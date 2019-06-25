Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AD52844
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfFYJlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:41:37 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37315 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfFYJlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:41:37 -0400
Received: by mail-wm1-f47.google.com with SMTP id f17so2237154wme.2
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 02:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lZv8KAbp55RM40m6DNY8pmaw09T8ySbR9phfkpUXa0Q=;
        b=ABIqcdIKJohMrWw878g/I8CWRTE2GRshHbHkrx8O6o9VBu5kY4WU1jZV8I/ju7aBnC
         oKFpNbbdcmBF55G6swBdaGEhRJi/cI0uNqVeWgyeLwXColZ78IEUXsRncdUeflVjoCrZ
         xYZnuYyGb92VzG6BUpIck0POwXKgMI1BHi8uHz45fcR+2PVeZ5yn9a2/cWUxHurr/KvU
         nYEFPWHdV5dWG1OGmpoc8hev3vVKTzBxXLKuSomc6b6pfCOPn9/Renh0qnIzeBcl2kx4
         6CuD8LZJYiOyQuDHzdZMFR6FF2AemSP7l3px2036JCT7YRLJV+4FrF2uC/iPnChrCVXt
         HDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lZv8KAbp55RM40m6DNY8pmaw09T8ySbR9phfkpUXa0Q=;
        b=nIKMxhf0myuAPbaBx7gdak9PAKlUVjmjRDHmVzQ0swmbViyRV/4PCrh1U0iMzZeb7q
         +iJv+WLix0nOqVVMkRP6uTeLvlGNuHfUcCh3z+JwyRxyCD55YfIZZlz7lIeTufKkQVrF
         f6NjhwDKqxTn4BxXLTbCfJ68dIYW6eB7Lsg1QLYcTyd6qQMq8/xH8A2y9eYgCU7TYoPP
         08d2RuheXPr0rKu1fqG7GKvu2fy+unnUgvoImS6EEAcDMTeX/pt6C6VEvLazwqKA/OSh
         8EE1T1onsFaFRnjddz2Z7ApXbgXT8noPK0jqqwiOJPmfF1MP8ylaGvDOXH9HLpuBk43O
         FNCw==
X-Gm-Message-State: APjAAAXvt95TYMIEFoNeg9wcrGHODmx8yYi+BW+IZ/93UmTJviDcJM83
        bQUYHzn/qfSIJFMh0FKZPv6mmz5cIzjXww==
X-Google-Smtp-Source: APXvYqzAN9e2L87BQdEmm0jdbW5znFc7JNXK7brH9xv3NSw+JOfge1CWwUxvldPSUqwxtrM5BVYbig==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr18727931wmg.65.1561455695421;
        Tue, 25 Jun 2019 02:41:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y17sm22298207wrg.18.2019.06.25.02.41.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 02:41:35 -0700 (PDT)
Message-ID: <5d11ec4f.1c69fb81.b385c.b414@mx.google.com>
Date:   Tue, 25 Jun 2019 02:41:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 81 boots: 0 failed,
 80 passed with 1 untried/unknown (v5.1.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 81 boots: 0 failed, 80 passed with 1 untried/unkno=
wn (v5.1.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.15/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.15/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.15
Git Commit: f0fae702de30331a8ce913cdb87ac0bdf990d85f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 42 unique boards, 17 SoC families, 12 builds out of 209

---
For more info write to <info@kernelci.org>
