Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E03CEFB0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfJGXlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:41:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34648 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbfJGXlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 19:41:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so11421295wrp.1
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 16:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vna2fl8iKoHshkpJDjFiYtImEJKlk4SlK0Aon1JfBKI=;
        b=GS+iGdHgegSeTXEfaGkMmsYBhIHvfcAdTIZyeSb+O3A3ExOH8xwJuG98x8SfVsfEW1
         NwzA+cnJlBAus+9vdD1tubmICCscOt7xp4D3oFcYYrPDIvjDV+VAHtQ7G3kgjPUmLFvE
         a++rWka1Iew9SUQwszcm5MB1nQ+AmKgANafBeTxKhloG97a/A9nvTDeBMv6GBHW7bJgV
         HFxEhzu8j6qmffuCACRTj2+mtlF7ZA0pBLtO9B8efQYlebzOGixjiHR7wUDROGmcCiz7
         086MtTzdwb3Ry2wpe84C570FMc7azMxHCaQluFzePI4pCwNnW3ls02+wKGnVA64cKOdI
         cYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vna2fl8iKoHshkpJDjFiYtImEJKlk4SlK0Aon1JfBKI=;
        b=A84/Z595daBsgyoVT/H7o8f+EuKJaBKSG24ozOC5XuPjwsdaBZHheBiGiyXWyB8MN1
         Nb1D0MuBjYfcTZ6GCmIF96aJKIaEQwRf/XbxskdhJlq6OB/LcmRDmit64yHhILYrmcuM
         R5qywD2bFNPX8LhhDFVhbD9q8L9cAbvWiZR+BYLxaoqn8F2Utua+k8pqzE7ZdnlR6w+J
         usRCPV4EYvxfga6Lt0lczlhH40XHhb1U+ytJ3Msn0a+znDedOzYr5T7dw0nwHdQ7mETF
         fAp3/Gg2Bv8ncxGnsF/96VrYMhqEqGB+H7/DV1kwM60J/XyYBNKV7HVNfZ005V56bFRX
         wSNg==
X-Gm-Message-State: APjAAAVAVoPk8UiUwn7WLjTHkrnS+04WEoHEw8Hi+zAB3voYTkJNZu3u
        LuTv1I3jdfQzWzFCqMySUlkuz5lBTf9fMA==
X-Google-Smtp-Source: APXvYqxUS+obXniNgiysJMAC1oDra8d5k0HC6XqR+N7NNc9uTCBOmLZ/OHp2HFL8jSpVl+qwJXV0nA==
X-Received: by 2002:adf:e442:: with SMTP id t2mr17803526wrm.87.1570491713272;
        Mon, 07 Oct 2019 16:41:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c18sm14088366wrv.10.2019.10.07.16.41.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 16:41:52 -0700 (PDT)
Message-ID: <5d9bcd40.1c69fb81.c1825.d146@mx.google.com>
Date:   Mon, 07 Oct 2019 16:41:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 48 boots: 0 failed, 48 passed (v4.9.196)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 48 boots: 0 failed, 48 passed (v4.9.196)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.196/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.196/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.196
Git Commit: 140fcbee3e9de3d649c5cb313c4919bd07f0017f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 12 SoC families, 12 builds out of 197

---
For more info write to <info@kernelci.org>
