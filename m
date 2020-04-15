Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404431AB128
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438148AbgDOTHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 15:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1416832AbgDOSg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 14:36:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365BAC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 11:36:58 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u65so394846pfb.4
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 11:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=6gDAPDykvRYIOsfNOf+uf0ChqLsfwzECBZNSpH39PdI=;
        b=TJ8wUpmesVFW6pacLs1L2Fb5xHEAEE0PRfhnFUcJlsVg1+sQwJ1zulSX8LKh7LsRBQ
         VXu5gVuKQZS9ug/upo6V9bMtYBcVfG+eBGxgolqAmn5o0BKAmt/QWoRfIiSECpLAGZHe
         AF25pcOxj+xA65WSb2Q5VYEktr+3GfDDFYRAapvC+twr1gvr8yyBF4YI0XCdaTykho2N
         D4UO600f+7TyLx4JNRd8j3uNZHv3oOn3e7+JZrTi/9lFQrlr6CE1futBFnsNIp+mij7P
         mTuxEtqC3RscmZQ9cWlIVCJOL11B6cZ/olPECovr1sxi5nAoY1kVjrQsGaTMrOWiJxEB
         Srrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=6gDAPDykvRYIOsfNOf+uf0ChqLsfwzECBZNSpH39PdI=;
        b=A0tpuCwgVbYxuckNKSpS8huN6JNKqDOxiqAeJEwxDgzXc6IApMC9a3jWmpi3+UZKm8
         rK48T1dHteHNfqTPTaTXIaJWTJA0YDiRTLT2PocieJNYDv1bPrwW9cP/KZeqclqf9Wdx
         iEpNo2VoA25InEZVIJcXT3NPUsmIqcHcVX4O9OlxuFj8KhQkdT+T/BP8W6co0iMdneMd
         zM0ElNiuaXs1LlpSS3+YhpTgoFlLa6UiRoQWZgsBFuMaD6/HK4M2ALrx+RrbWAe7dJXc
         k5uBcjfTl+PvF3ChEWzvwW1mchfetykx2KXxrd3uayLfj6z+xHhHFWgxCwGYxzI5F/dA
         0nWw==
X-Gm-Message-State: AGi0PuaIdX2leLVRt9Vc8jhPO2L8Zvc8PTCtDBoPAJ/LJLv0JphpRbl1
        R3S5LBnSAm8Ol3lIaRkRNmGH+nlv
X-Google-Smtp-Source: APiQypLtcncexllvljS0dNvQJ0wQtj7ApEjwU+agd26b5JFGBSxHWfB127iCRWj/WwyKZhr9Txk6Fw==
X-Received: by 2002:a62:5e86:: with SMTP id s128mr30508792pfb.157.1586975817567;
        Wed, 15 Apr 2020 11:36:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l185sm13190853pfl.104.2020.04.15.11.36.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 11:36:56 -0700 (PDT)
Date:   Wed, 15 Apr 2020 11:36:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Stable RC build failures (v4.19.y, v5.4.y, v5.5.y)
Message-ID: <20200415183655.GA66707@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The folloewing build failures currently observed with stable release
candidates.

Thanks,
Guenter

---
v4.19.y:

drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:392:14: error: 'chipFeatures_PIPE_3D' undeclared here
drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:397:14: error: 'chipFeatures_PIPE_2D'
drivers/gpu/drm/etnaviv/etnaviv_perfmon.c:402:14: error: 'chipFeatures_PIPE_VG' undeclared here

Culprit is 'drm/etnaviv: rework perfmon query infrastructure'. Applying
commit 15ff4a7b5841 ("etnaviv: perfmon: fix total and idle HI cyleces
readout") as well fixes the problem.


v5.4.y, v5.5.y:

drivers/mmc/host/sdhci-tegra.c: In function 'tegra_sdhci_set_timeout':
drivers/mmc/host/sdhci-tegra.c:1256:2: error:
	implicit declaration of function '__sdhci_set_timeout'

Culprit is "sdhci: tegra: Implement Tegra specific set_timeout callback".
__sdhci_set_timeout() was introduced with commit 7d76ed77cfbd3 ("mmc:
sdhci: Refactor sdhci_set_timeout()"). Unfortunately, applying that patch
results in a conflict.

Guenter
