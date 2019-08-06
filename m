Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55883D4C
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 00:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHFWXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 18:23:25 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38790 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfHFWXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 18:23:25 -0400
Received: by mail-wr1-f43.google.com with SMTP id g17so89373278wrr.5
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 15:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gHZTINE8R/TKlji6cyuE14u+92c3Sq7aCX7G1VAFTg4=;
        b=Xyc2zoT5y8g2zj1ijeenHSUiwjmxheJBfhDgY3JD9hX4ADDy4Zxx70VlwKMhZ3si5O
         fGXn/9H8afObNpj7irQmgiUg7xuRCx0WNJGWlnLZ7xbWVe9al8QYmcDExpxFKgSyqUPk
         w8N9ooF/RBfQcFXqS1C0YvRmgzxAbNLvDQvgxryn2a3jhOMeFDcUl/WaClZEMOtb2VyY
         /tiQQ98KQ5i3vCCXq7agupZYNUn6Dypo7SZmfD0lmhksPfojS5SBEyTzZBjWvBZ6MZ+y
         jmqwPLG2F2p2vCqRP8EWO36ZUihxnXwORgC/pddx8jJB23iCxuNN9QHpM8yyYN787ozX
         03Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gHZTINE8R/TKlji6cyuE14u+92c3Sq7aCX7G1VAFTg4=;
        b=WsES10v5BQgxpiuKTpfoJZnR4qcnp9v4DYzgqCnJSNHAlUMPAOCJZaxXln6ev/noTN
         hiwDqohxvx8wqGBWGKkY/OlHZujAD6okF1ItgWrQAsA4T+xl3fWl53VQPtVeNWrHUMc6
         FzNN3YfQtYpniZuMcWT4vrtXbkApZ/+WdfGhmsdFY4W4zX5+k66whdos8f8D04E+T8Re
         +2MHh5HTIH0ZxdaA3uame7E6EHzmkIne6G/DmTxR3w4SyWmNaNcIoniA8LXNLQxpRG7y
         n/5yA4149eiIXOwQe891spFqOKstPrvL3Ttup/cvigFVWPyxQ5BR6L0SFxtZBMl0w7lE
         BKmg==
X-Gm-Message-State: APjAAAXkOmBQ3fsb1XW+rvvBU8l3hcOswZ4fnsvcbUquOg9w7ea+Vv4F
        iLwUnLf6LCCV2zQvX2OoEzZfT+zaE37PuA==
X-Google-Smtp-Source: APXvYqyB5nIkdQTOKEjwU0VVWAk+bBF5pnH1dMpxgQIJGOEO2QJ3Ulv7FCvzO3u5Am7Liju+D9HEdw==
X-Received: by 2002:adf:fa42:: with SMTP id y2mr6607055wrr.170.1565130202881;
        Tue, 06 Aug 2019 15:23:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm61007461wml.28.2019.08.06.15.23.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 15:23:22 -0700 (PDT)
Message-ID: <5d49fdda.1c69fb81.4971d.d1f1@mx.google.com>
Date:   Tue, 06 Aug 2019 15:23:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.65
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.19.y boot: 70 boots: 0 failed, 70 passed (v4.19.65)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 70 boots: 0 failed, 70 passed (v4.19.65)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.65/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.65/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.65
Git Commit: cc4c818b2219c58af5f0ca59f3e9f02c48bc0b65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 37 unique boards, 17 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
