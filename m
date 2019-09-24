Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4988ABD594
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 01:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391669AbfIXXu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 19:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbfIXXu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 19:50:56 -0400
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 001918535C
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 23:50:55 +0000 (UTC)
Received: by mail-pg1-f198.google.com with SMTP id h36so2354773pgb.3
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 16:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BvpCovvwFWNXsPrE904hwX8MHJA0WV+o9Cn3zEzjHkM=;
        b=MYYNQCfCdm14O4CxMXa+4Of0R7s6Qt5wh9RUnVGg4Uw+Js7ImOO4msX63PggyVfcip
         Sv/y1wXJ9mPMCusPM4LD+hOu1SW5W+fOT2TlGS6gyj377sBVTlasz++kb3D8shuaETke
         zuiLxz+J3GxADmY50najNROFwn+XSjBz06m8YBYmhk3xqD4+vFVuD/FUplpoiGugtDD4
         8zIx2yfk2KlfIRXgIQOAboN5g10KFjZGUXUam3lFOofsfYjEh93yULI8Jm2k0/tI/dAm
         3F/xnf2HvmZ+WRmIyeeyTG2i6EVRGXUw0k3wLRWTEFHzKi0lPabrE4bihbAlvQpGnVHq
         x26w==
X-Gm-Message-State: APjAAAUFmJr510btxQzYCxZRsX9iyjefqycYSaYRd8seyG0dC1LRZSSm
        EK0dGf4YmHCETVyHDRJ7IxNSl6m3MNSY3TBf4RWiDeVarWvxxGrnKAPQ5TVNgj+hVvS7fohmux7
        rweBoymy5aDX8TMKq
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr5938763plo.112.1569369055207;
        Tue, 24 Sep 2019 16:50:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz85WbF1RvcCkkWA+tLZRlOGeyK3rwUOqS5VEXrCF0Lp2icjzwWy/nQLCdEqWTS4XfXdHPxQA==
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr5938738plo.112.1569369054888;
        Tue, 24 Sep 2019 16:50:54 -0700 (PDT)
Received: from indium.local ([12.157.10.114])
        by smtp.gmail.com with ESMTPSA id 127sm5079500pfw.6.2019.09.24.16.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 16:50:54 -0700 (PDT)
Message-ID: <2a8b96c85ff61a97e8a11c9ce6cb8e1a0af9c812.camel@redhat.com>
Subject: Re: =?UTF-8?Q?=E2=9D=8C?= FAIL: Test report for kernel
 5.3.2-rc1-e326a3d.cki (stable)
From:   Major Hayden <major@redhat.com>
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Date:   Tue, 24 Sep 2019 16:50:52 -0700
In-Reply-To: <cki.7ABE258C7B.UZNH3U8G6Q@redhat.com>
References: <cki.7ABE258C7B.UZNH3U8G6Q@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-09-24 at 19:37 -0400, CKI Project wrote:
>   x86_64:
>       Host 1:
>          ❌ Boot test
>          ⚡⚡⚡ xfstests: ext4
>          ⚡⚡⚡ xfstests: xfs
>          ⚡⚡⚡ selinux-policy: serge-testsuite
>          ⚡⚡⚡ lvm thinp sanity
>          ⚡⚡⚡ storage: software RAID testing
>          🚧 ⚡⚡⚡ IOMMU boot test
>          🚧 ⚡⚡⚡ Storage blktests

Please ignore this x86 boot failure. It looks like the machine ended up in a very odd state that is unrelated to the kernel itself.

Sorry for the noise!

-- 
Major Hayden

