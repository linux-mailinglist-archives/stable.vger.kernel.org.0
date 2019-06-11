Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4FD3D209
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 18:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405575AbfFKQSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 12:18:36 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35802 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405444AbfFKQSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 12:18:36 -0400
Received: by mail-wr1-f48.google.com with SMTP id m3so13756886wrv.2
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KKk+GtYCX/lvp9RZ+mUx12Jo9yBTyU50oo4UKIdm45s=;
        b=z0e1/Laa+ojv0EnpwcDklAggL398HMc+oTgsIQNczdjZ5LSTECNII2UG1xNEoSy1vo
         2i2TxVQ5TpvgXHfLRe66ZE/sdezpN6m0d/ypBpQ+hsfnwHam6Q1JRhEPEkBRXJvSdRF3
         6thzXftBV7/QB6/ukVWNiYXz1quC7oYld2nSOzOwJWhn2i0qaPVjoO+jxqi0dssFe1WV
         FDt7096z4kSFKhvlqsVvnPoVhiinJiR9nJe56xwPAiyRBNR+QAlxN7x6JkjZiOhpIT37
         6wiy/bum3HobiYG1xTymBsZE0adXDmclsVuhack7UcvaQXlQZUH+LnRsVhVrmLL4beHT
         IM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KKk+GtYCX/lvp9RZ+mUx12Jo9yBTyU50oo4UKIdm45s=;
        b=Gk/4LvQYaQfdKXly+BsuCYapUaclsiYP+iMqDe7FmsAdjJYlfZ+sKGq5itQjQ52Zvl
         Z5nLJgYEa+G5xsQlxbjfT89jeZXUg6eo5gENvsh57uen4ch1QEmfIzjZPGyrcV1B1of4
         bBvz4fytfcttSpTGwpIV/cpNkf5mu3yuyvgyS8RgwoxgRNazLcCMwRQTzCaBEv0QnsZJ
         MQ/sthNN0iITQbgK4B57iDq+UkHz0meC8FCEJt+30bqCBK9nh4AlK01RSmG5Mfu3vpMY
         XTl6uhcIrbrF8f11JcW/ROOcKGS9iFgf4hEoAS7BHJDtUSTgGjwS+hekzig5YZ7An3Lp
         wrIQ==
X-Gm-Message-State: APjAAAUbD8UelQG+G/evxQdBSs34cne178E5iGlg0vH3IGhnZuXP+fmR
        7TGWAa3jQ9gvNtGeHwlHO4F949nR7NuUaw==
X-Google-Smtp-Source: APXvYqz7cMg3dDJL+SQhN7OwQuwSwZDlp2uh2x1bWDwPsnsH8uv830KX0kwWx9e+fv1O9ywRoNKiHA==
X-Received: by 2002:a5d:514d:: with SMTP id u13mr34125365wrt.77.1560269914888;
        Tue, 11 Jun 2019 09:18:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c24sm3257305wmb.21.2019.06.11.09.18.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 09:18:34 -0700 (PDT)
Message-ID: <5cffd45a.1c69fb81.9f43d.3058@mx.google.com>
Date:   Tue, 11 Jun 2019 09:18:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.125
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 59 boots: 0 failed,
 58 passed with 1 untried/unknown (v4.14.125)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 59 boots: 0 failed, 58 passed with 1 untried/unkn=
own (v4.14.125)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.125/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.125/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.125
Git Commit: 2bf3258a12af6508d9c0cf17bfa895c5650d2dbb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
