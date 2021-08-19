Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357CD3F163D
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 11:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhHSJdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 05:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhHSJdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 05:33:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE78C061575;
        Thu, 19 Aug 2021 02:32:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h13so8093073wrp.1;
        Thu, 19 Aug 2021 02:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmf3umRfv4KMZ4uQ33/nDRLk5ExaW9fT/xorODYlDPc=;
        b=enn9Mp7+BHj8C9UfShybnnOLllZFUZKmPD3lFyG54k9reTcqpk5AkxO9UJohwcucyj
         iwQTIO2npa3wA1k0iA2wE7V6z7SL4ojVklZY5i3FEqRvn4HUvKcbQ+iVNkQcHlP7P8nr
         dXs64snQ0/F7klMWbgLLpuhDGlDvVjRT9uF99TOej9/zM8aB3aYGTX9Hk99Aq3NgP67C
         pvBBzhwuDuAw+apun2yEkKhFWNpwf6PX6pShYpQQ3XwfqIQk6/Ctee1Vw+Ufu54fgaqN
         D2xY7doZWziyJqOA9Jdc0P2uVWDFEqq5lt2ctpWfR9hckwMDAbkGL8XMJ/LOJGqy4Wui
         AlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmf3umRfv4KMZ4uQ33/nDRLk5ExaW9fT/xorODYlDPc=;
        b=ZBROK+rI2aIW4X1H5M0xDyck1VXOIEQfGWbFZTokqutDoZ5g3reP/lzq0zUEy1dC1S
         gplRn+AXQCipKw2ansqISGmtDuMMBQtR37aO98exobECzXcqNfFJnpmKqtWLeKvdFlFX
         q7uYqr5AxMrsjD2woFUP6Dz8Dqx3ppafj9dU/YiOLC122GSxfB6x20nRERhCCd7IT+CA
         cid5EIbZHMiX9uJ5wAOF1vCm5AxzlhOkFEKdIcUWQiks85TwuzXSiqqx0ltaqdTDvnOy
         OFCVUwWp/pLUM4rs33FAypUk0H4brH+rjrLEjPrbDdOWzGhs09qNeUiJj3YUOyJEucZ0
         TrNw==
X-Gm-Message-State: AOAM531AZKqioJNkjxFBUWrKIBUV2MfEh5LJbo9qLJfBI1z2xjv/9prj
        Tw/Xf3aGPhOm05TZjBWuv9Y=
X-Google-Smtp-Source: ABdhPJyWWlLboikpd2then9nHSZfdRg9YfDbpOedyAGwGxARsjMptNU5YHc3mcTz52AsxgCxk/sorw==
X-Received: by 2002:adf:fa11:: with SMTP id m17mr2592459wrr.323.1629365548547;
        Thu, 19 Aug 2021 02:32:28 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id h11sm8485061wmc.23.2021.08.19.02.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:32:28 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH 0/2] Kconfig symbol fixes on powerpc
Date:   Thu, 19 Aug 2021 11:32:24 +0200
Message-Id: <20210819093226.13955-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear powerpc maintainers,

The script ./scripts/checkkconfigsymbols.py warns on invalid references to
Kconfig symbols (often, minor typos, name confusions or outdated references).

This patch series addresses all issues reported by
./scripts/checkkconfigsymbols.py in ./drivers/usb/ for Kconfig and Makefile
files. Issues in the Kconfig and Makefile files indicate some shortcomings in
the overall build definitions, and often are true actionable issues to address.

These issues can be identified and filtered by:

  ./scripts/checkkconfigsymbols.py | grep -E "arch/powerpc/.*(Kconfig|Makefile)" -B 1 -A 1

After applying this patch series on linux-next (next-20210817), the command
above yields just two false positives (SHELL, r13) due to tool shortcomings.

As these two patches are fixes, please consider if they are suitable for
backporting to stable.


Lukas

Lukas Bulwahn (2):
  powerpc: kvm: rectify selection to PPC_DAWR
  powerpc: rectify selection to ARCH_ENABLE_SPLIT_PMD_PTLOCK

 arch/powerpc/kvm/Kconfig               | 2 +-
 arch/powerpc/platforms/Kconfig.cputype | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.26.2

