Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9414C8DF
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 11:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgA2Kn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 05:43:28 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55855 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgA2Kn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 05:43:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so5625161wmj.5
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 02:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eYYhKxmDjTNCTxN0aNitgwRahCtiMUnMbs8RaKcokTE=;
        b=UkDbQT/tH/UpgFua5ONY+p3/oaHiPyV5Ec6w37OoWl9SZ/46HnUDBUtnNWOEdemQXZ
         Iw6UXuUbuLkKm75J7UUZYZp21x/AeFNHTug7I3VVdaDVhf8Hdo9DbYdhdJKOppUnRJ1T
         AtSZtS6bpAHszrLdCruPBameyiDUQHCxkfY9gORHDRpwsxFTJ8sgqQIt85mSTwUgtDPR
         uszAfzvU1b3ttrNKE5dhsEgXb73aQZiRZ2aNP2+oHGmvJSmNebFqORoXT/HQm99lSBQu
         Q+Tx3WMRZHcl70cyyQp5G62LAWN8u5XoGxyo5wbOwJ3pQdBY79PMApPqCGwHjNU9xk25
         YF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eYYhKxmDjTNCTxN0aNitgwRahCtiMUnMbs8RaKcokTE=;
        b=qd4ZMxlfPC+VFBDEJmOwpIm1dqn/2pwdGWECNzpNlVa6YvEhpmV+mLuk8Iz9F/LXbR
         qeHnTqU+K9DvhfYainufjxbOsziwStiTfaqAu9Ga5fzcvSdGCGZNHso/BIEJaX7nTa8/
         3UKXITZVRPftTt6rNsHmRdL2ZzBnP/WV8LzTxt4iQZiJoQCMiYygItPI+nWzgUCy7Djk
         eeVlSdjyGpGCaZbWlJOxndpdqVWx2ipaxXWbsLgPKukYUnkc0C5W5BFrqSIwnitXIchm
         d9G+HP6+RJLxJQmFLZvJhddPXNQ6RSm10hIoA1OyKij5HSeDeyOiiWlmJ7lGrPxm3VoM
         zOtQ==
X-Gm-Message-State: APjAAAV8lECXUgThSSjsr3YpfZRzr2BDBF9D+AgMX4dgBTlJgxscKeXf
        XyDdsswE/+R0w1SHck7531MKJTOT3iAbtg==
X-Google-Smtp-Source: APXvYqwQuJABzuTBaXDB/gFTOmnlq2qho6Eb+b+u0aN52UcSpzRztPKMPI34d18jh/oS/Hs1seXLTw==
X-Received: by 2002:a1c:1dd0:: with SMTP id d199mr2929937wmd.42.1580294605639;
        Wed, 29 Jan 2020 02:43:25 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w19sm1749521wmc.22.2020.01.29.02.43.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 02:43:25 -0800 (PST)
Message-ID: <5e3161cd.1c69fb81.3e520.74f6@mx.google.com>
Date:   Wed, 29 Jan 2020 02:43:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.15-105-g4acf9f18a8fe
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 83 boots: 0 failed,
 82 passed with 1 untried/unknown (v5.4.15-105-g4acf9f18a8fe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 83 boots: 0 failed, 82 passed with 1 untried/un=
known (v5.4.15-105-g4acf9f18a8fe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.15-105-g4acf9f18a8fe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.15-105-g4acf9f18a8fe/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.15-105-g4acf9f18a8fe
Git Commit: 4acf9f18a8febb1cd7bd9c284ee494fdeb40ad96
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 15 SoC families, 9 builds out of 172

---
For more info write to <info@kernelci.org>
