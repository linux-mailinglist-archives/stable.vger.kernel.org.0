Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9456197089
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 23:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgC2VdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 17:33:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37163 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgC2VdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 17:33:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id x1so5915311plm.4
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 14:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xCJS/qSV+9PFqHglloSdKWew+uZsleBm6KwvCU4mWPg=;
        b=JrlXL6+IJJlb7MWiOs1lGugjk0rL0haqaymhHSW7sib1NAcVTALOvERDSOpKGhvVME
         /fFAazdrw7xZuR7CH3FXV9WeGEXUWzgrDwh4XKDp57UPOan9gVljWPQt2VUAk5ITecty
         JXL1cQ218m+U+6cefqkXtW9U4VoZkB+u+TwRtGsGH9NoQf9JFK1rUBrQ5otMkRQpZ0E4
         Ric6FcM5HHORVdjTgkxaHcMLxO1r2ZHLpZaItQdz1QCzzQkuKDGXCjpDfKdvyVkeUc99
         hwKVUMQg+LKGX7Lhc2XWgPvamK/ySin6+LGilGKIQ+lg9nB3r/SebWfLwgDugcWq98qh
         beHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=xCJS/qSV+9PFqHglloSdKWew+uZsleBm6KwvCU4mWPg=;
        b=XVduOvwwEov1Dtm59I5M8QSSOGzLoHPiN1oCywhibF/qJQ3xXGP2DxzRm7mQFR/A15
         8Zn18bpvtKQVSL8koLBKzbxbNOhOD0MOB447haZl5Au6KuyxoXqlsnrLDl24R2xaJ9Qr
         jO9k8vyo9/noNph19LcE1MgR+YezkajZDmrFwarSrIvQC52Uk+3xzX+qS/p/oFbdQtRT
         5ApXrDJ7ly/3KphL0a11PbeDJ68GEQmI8i+R3D/iEetWWPGP98lJZbOICZMwKhF1/bov
         uvEhloW7dq+CN16Nz8tq2+yUCg2S/w42Dg5S8G+CZUUFB1FyAPRbPXwr5OiKmR+miikW
         SzeQ==
X-Gm-Message-State: ANhLgQ0Z3ca6CHmYvKUbJLlC1ZOZRWWhinIug9aMLG6j61fKZOviEN8F
        J0ZrVvT2AP9DBbLSQKlrzljUhZjN
X-Google-Smtp-Source: ADFU+vsBiahUVULAvbgHxacj9WBCoQL/OkxB4NczuOofaARLBjbIXKG/emVnZlx2kYkn5qz3Dk8rUA==
X-Received: by 2002:a17:90a:5805:: with SMTP id h5mr12327524pji.175.1585517604323;
        Sun, 29 Mar 2020 14:33:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 189sm8212063pgh.58.2020.03.29.14.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 29 Mar 2020 14:33:23 -0700 (PDT)
Date:   Sun, 29 Mar 2020 14:33:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Patches for v4.14.y
Message-ID: <20200329213322.GA23871@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to v4.14.y.

The following patches were found to be missing in v4.14.y by the ChromeOS
missing patch robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
- The patch referenced in the Fixes: tag has been applied to v4.14.y
- The patch has not been applied to v4.14.y

All patches have been applied to v4.14.y and chromeos-4.14. Resulting images
have been build- and runtime-tested on real hardware with chromeos-4.14
and with virtual hardware on kerneltests.org.

Upstream commit 76fc52bd07d3 ("arm64: ptrace: map SPSR_ELx<->PSR for compat tasks")
	Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
	in v4.14.y: 053cdffad3dd

Upstream commit 25dc2c80cfa3 ("arm64: compat: map SPSR_ELx<->PSR for signals")
	Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
	in v4.14.y: 053cdffad3dd

Upstream commit 93a64ee71d10 ("MAINTAINERS: Remove deleted file from futex file pattern")
	Fixes: 04e7712f4460 ("y2038: futex: Move compat implementation into futex.c")
	in v4.14.y: 0c08f1da992d
	Notes:
		Also applies to v4.19.y.
		This is an example for a patch which isn't really necessary
		(it doesn't fix a bug, only an entry in the the MAINTAINERS file),
		but automation won't be able to know that. Please let me know
		what to do with similar patches in the future.

Upstream commit 074376ac0e1d ("ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()")
	Fixes: 39611265edc1a ("ftrace/x86: Add a comment to why we take text_mutex in ftrace_arch_code_modify_prepare()")
	Fixes: d5b844a2cf507 ("ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()")
	in v4.14.y: 0c0b54770189 (upstream d5b844a2cf507)
	Notes:
		Also applies to v4.19.y.

Thanks,
Guenter
