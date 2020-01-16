Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769D913D244
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 03:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgAPCkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 21:40:55 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38555 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbgAPCkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 21:40:55 -0500
Received: by mail-wr1-f53.google.com with SMTP id y17so17624695wrh.5
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 18:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bHtst3UPXAsvy6XRY2HjGgxWAm+ICJckSgaYlSTUdKc=;
        b=TkttNW/01ZtmIEDE7QtGhwjU6kVSvr7LgBFwrP6VtdhhO62vQWzZxi+YxpO3Ya/Vm7
         VYYMN5jhy/LxTxkZieNIu+tIUIKuKRU4doDPDoPTGl7yUrc5VegCvVmZ8w4ZPs/kWDOd
         stuIjKNQuzjIcikWaip8SxlsMdCGMJiUmKbyXsKS9Mk2As76cYNUVdhEXy1kVdPi11L1
         l5yZpDa1hbJig4QxHcmcJlfnUf7KaCVHR0y54HsJXo7F5GST4VoEg7b0F2BY1BsjhXaq
         HpEwgRs1PB72fF2QtBg0YAE4BIH81Ad3wAADB3BOx12Qba35gvd3W6vgQJRHXRbL/fv4
         sfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bHtst3UPXAsvy6XRY2HjGgxWAm+ICJckSgaYlSTUdKc=;
        b=j3E0oPf73073I8peaajZjZHMpejAoT+J+gKfenypSleysM85NFrlZCB5qItpZ6A4be
         ty8r56DvqP+spbtYkEd8xIgC2tuIRAsh4OjtEUiNyvuVSDRiiuxfUvlbA7NCofb4L0n0
         J7xLG2GLRGMmkhQ+fmTgDXFX27xLd7ESeY9AuIwUWtrZCRVj27twz0UcBvjiIZuaXfku
         X2klhQ4ax0kws2L8v/8zIQXlrfqKH36B9GHYIMb3guD1Zo59P9N+1QkvdiF+0Khdk4I4
         r+0ZGG6CPRHxbP03I8EmAoGuNgC05/iStaE083Kl69KHozFntC8najvGvFARjVwbawMQ
         3w+Q==
X-Gm-Message-State: APjAAAVwwrbpx1Vvu9tNnx3wOJFmoUUUYX4TJ0dwWPSlagrDv6eQOXwo
        pGklrhWW3cMLl6o/N275VIDlGNzPv1DPWQ==
X-Google-Smtp-Source: APXvYqwvxdWiEZ48BPAnzNIgQ1k3rwM54pww6w4Mu0/wPLgVSjkswAknN+aeYEeyXlw+VspIWT/VpQ==
X-Received: by 2002:adf:e5cf:: with SMTP id a15mr498179wrn.140.1579142452948;
        Wed, 15 Jan 2020 18:40:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c195sm2005120wmd.45.2020.01.15.18.40.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 18:40:52 -0800 (PST)
Message-ID: <5e1fcd34.1c69fb81.5a502.71c6@mx.google.com>
Date:   Wed, 15 Jan 2020 18:40:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.96-17-g17243698cdfd
Subject: stable-rc/linux-4.19.y boot: 89 boots: 0 failed,
 88 passed with 1 untried/unknown (v4.19.96-17-g17243698cdfd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 89 boots: 0 failed, 88 passed with 1 untried/u=
nknown (v4.19.96-17-g17243698cdfd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.96-17-g17243698cdfd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.96-17-g17243698cdfd/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.96-17-g17243698cdfd
Git Commit: 17243698cdfdf70978362de86bcfee0a0acdac2a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 15 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
