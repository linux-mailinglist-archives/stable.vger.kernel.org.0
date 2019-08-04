Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABA580B09
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfHDM5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 08:57:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39984 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfHDM5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 08:57:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so70599399wmj.5
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 05:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2bhDJkSceCZKp12vrerYVi3lVXnwP6K8lMBqVJUXf2Q=;
        b=farQqi5t2ZGakqWBb17toXtUcM4ULaDQsgQl2qZkk2tCOkKi/MkP9+/6xKdgRXUDxr
         IiffN+ol2ilfAmEZpGxwYtOCIztwYAn/nYgE+v2SfFksuBr8ifNIdhBmTs48cTkREE0y
         452nrl25ANbI5Y/aAP7qOHN2kMfkykVhT3IRFH92AVz2/KYzB6qHq1vtD0L0twQg0z+H
         woAnBzJfAnOv2fCT9+rWyRXaMxDGplF9qP98d/4g7vmkLBr9bC4lk/a6NiH4wEBFv/Yk
         k8sNJW3RjQMqRSVo3vQT6McX0AXSIko64ZOlm7DuwATX8xV3WFBl9OVWiofIf9iuNNk3
         XBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2bhDJkSceCZKp12vrerYVi3lVXnwP6K8lMBqVJUXf2Q=;
        b=lDj9SC2Vvzn+th7snHjJ42DrooogYKdn703aQHGrkcac85OwAVjBFc4MglncN4x2uF
         d024eXwm7EWQ75rUok2CtaD9YrkACXPY+0LundVkzqUW4krsoMCFHfmkxFtgdzkf0GLu
         PasuCGoKhcPgcwKhS7uiT/BExNAkgXCktbnZ84UtdLO8WLduBoZ4nsBFP12txzXCc+Yk
         QRcpirz/oY7psMDGZplEgjzfEQLUNRjLHg07DG3XiVcHF+PLpmbUD8WJ7tYC4BBK0gv6
         aq/yYRIC+VPzIlhfoETOOu2zWwvxUSQ5vitV5/lSAsw89o5Q2fyLSB2IUYSDIjhbr+12
         LKjQ==
X-Gm-Message-State: APjAAAWFY6LZjIAdTjPC8n8KHg7/jopR/kGjjKWQizsOgAYYBEuzLbG/
        yXfDjcitMIg2JAZaxw3qQKQ+u4DA0oc=
X-Google-Smtp-Source: APXvYqxllOt1LAZ3gPil67Ll7as0wmEyd3ltpQE3EPzEapBb9k1oy/h+MrM3GQFvs4gzkvb9mS3VeA==
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr12743220wmj.87.1564923443410;
        Sun, 04 Aug 2019 05:57:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 15sm56908550wmk.34.2019.08.04.05.57.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 05:57:22 -0700 (PDT)
Message-ID: <5d46d632.1c69fb81.381cd.a99c@mx.google.com>
Date:   Sun, 04 Aug 2019 05:57:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.187
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.9.y boot: 47 boots: 0 failed,
 46 passed with 1 untried/unknown (v4.9.187)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 47 boots: 0 failed, 46 passed with 1 untried/unkno=
wn (v4.9.187)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.187/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.187/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.187
Git Commit: 97d7530b83e3f515d5a3242019fdc2b5848d5a7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 20 unique boards, 11 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
