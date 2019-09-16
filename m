Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084F0B3A09
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfIPMM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 08:12:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39613 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfIPMM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 08:12:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so9526270wml.4
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 05:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WqraI47jksXZ1MlszlCPXX9TEaH+fuoFns0eufFhgFc=;
        b=xSWRaPf9UlIvYJo6z7yJvytreZGU+/JXv8I2d/+wdubOhVgeBiqLa5+8Do3ZDD2/Mb
         VlljWWzvpSbZlm5D+KtAM7kmH0s8Q2gG3Nf6pE4O1FOSUXWxVMGCwA65VWkQkpu00ZnT
         abjjIbLTxlfJn2TXPwvWZ2xaKo79RPkoVlqq5RDwKGVZIevgMqq0W+qzZOSv1ffdfyVl
         0bBkwB4jGi2ANtzRbm+GH944SsRBnHTSJZqadnppz4Ke8DBqlbL+3bRguQ6NzGgkvwJY
         WSrq+wbklzkDKiCRnVkBvBSVwUZXUpsBgF6f49maqVtuMAAcjAWBaO6dNyC4DiPOCuSt
         GRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WqraI47jksXZ1MlszlCPXX9TEaH+fuoFns0eufFhgFc=;
        b=Nz679eHy65YiTe0E/Qa5p2yPuwMg7D0o8dtKQEBxoRvrRKGDjSQpkDVsT2V8EB35ul
         rV7QYUw/jc/RBiwtzbw/uL0iuqWUe1WMYmunTIJEbEEt0nB6S8GUqNYT7A3U9EdMi00f
         hEz7eV/m7T/+AdsJ/2+fD3fTh1tahWlg+MqttWVya5Z8C4ziCfop4bxw8hb1VdVkgRNu
         M8xGmrUnbYr+YZt1KfXYLP3NnHiS7WfoXP6HklmArA97B+s9vZ7419KTeUQeCxXct3YR
         lndr2JxBQJ38QGc0++fiTtVBPmSZ8IbW4q2F4QlTAbGTvqV7GeXlNOL7Rv1ZymPgdD0X
         VI9w==
X-Gm-Message-State: APjAAAXvS2SXProuBW5dumI66KN4AdHILkjGQXlJwfNLLHHzPPOo5NU+
        OVgaD6CgeajNj9Ok8ZmRGhGZG/USdK0=
X-Google-Smtp-Source: APXvYqwq2vUD9xP+oPnLQlQByWK30hc5iiiCs7ED9uz1LTqkOMDpira6fStp0twytMImk6Uoa+DL2g==
X-Received: by 2002:a1c:99cd:: with SMTP id b196mr13456464wme.83.1568635973369;
        Mon, 16 Sep 2019 05:12:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 33sm47410606wra.41.2019.09.16.05.12.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 05:12:52 -0700 (PDT)
Message-ID: <5d7f7c44.1c69fb81.91aff.a52e@mx.google.com>
Date:   Mon, 16 Sep 2019 05:12:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.73
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 91 boots: 0 failed, 91 passed (v4.19.73)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 91 boots: 0 failed, 91 passed (v4.19.73)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.73/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.73/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.73
Git Commit: db2d0b7c1dde59b93045a6d011f392fb04b276af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 18 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
