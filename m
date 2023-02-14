Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C96968BC
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 17:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBNQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 11:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBNQFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 11:05:31 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D4892
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:29 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j23so16230736wra.0
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SV42mF+MU/yNNSvEQ3cDck0zrBQnXXK1gKwku8LNjTk=;
        b=gy/5cZ2aMrhndW30F+FCqaYK+HxAuA1zxnPhxQFUiywLxOjmNP3CwC43CPdfr5BH/v
         T5SUWAnNZxQie2Ft4qQO25+5nntY/7fgnoOUfqwIo8MBEjvp6R+7kjvVYwxca5Zoyq1W
         Hh+0sj/ih+pLIZGOQ1Gv3ideoWjbJv6hGThumetKQL9SMhm8NydCosYx0AM8DtJSkLra
         Iz9H8AVRmev9rWw7s5Wqnx7n2Kjg2pQ4TBdm0mmD2S5tF7AGVYFWQIhWZwo9SpKBRQ8/
         z6bvcVM5GmyFUDO/k+dWvH27WLa1GMeXD4UkidOiW1W5dqX7pZcRz+vHwyO3QhGXPvbf
         OPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SV42mF+MU/yNNSvEQ3cDck0zrBQnXXK1gKwku8LNjTk=;
        b=uDdmcmEBDe3HzQg9jIH+t0rWSB8GoaeCdPxlvVQT3EaMw5/I/Z5QrxAIFvII8d1Pu0
         5evWikJCAFrcUX8EHfv9YR/T3ZqcNhrj+RrZfWEhp0bkV1lQj+53nOFgc2Tjb2riKLj8
         Z0iGKkEEQ8WbmucEaZ0fsu6zdP3v6IKrjIzmmwWE2/fPbryHrK9yzUEpmvK3WleT9XSX
         zZNHyp69LBgytqTOT+WYXNA/5LH+iV2cH3yvkLS5Dz410xuM3A4n9KQld0pUhSFiu/XY
         QKsnuvv2iQy+ZecGJbeAzTvKB29zLmhDhLFoEH8IVmOT1DCd19Qp3o9Z+RgANmekT0yF
         6qPg==
X-Gm-Message-State: AO0yUKU/gRZRBwFzWvkiddxemRhEENsHG35GwX2nuB0GHs3AgkrCrra9
        3y68ws6JW+9tPZ/TotCl2nfIug==
X-Google-Smtp-Source: AK7set85EfmJ3xaVxXEKcfjUrXPWb7MiIP1nWM0eDC4AkvRs+E48pEpJ7TfTYo/5FNO83tFCSsa/2w==
X-Received: by 2002:adf:fc86:0:b0:2c5:53f8:4054 with SMTP id g6-20020adffc86000000b002c553f84054mr2348438wrr.51.1676390727983;
        Tue, 14 Feb 2023 08:05:27 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id bg30-20020a05600c3c9e00b003db012d49b7sm4435537wmb.2.2023.02.14.08.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:05:27 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 6.1 0/4] mptcp: Stable backports for 6.1.12
Date:   Tue, 14 Feb 2023 17:05:06 +0100
Message-Id: <20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-v1-0-02f36fa30f8c@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADKx62MC/z3MSw6CMBAG4KuQWTvIVHDhVYyLUgZpArWZKQZDu
 LvFEJf/I98KyuJZ4VasIPz26l8hBzoV4AYbnoy+yxlMZS6VoRrnqEnYTqjJtiPjfxh9mBe8IiE
 ZFEc4xeQi9n5hxa43tW36mqghyHZrlbEVG9yw64cl7nwoJZWf/ReFf0A+3SG38Ni2L53TAkm0A
 AAA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1591;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=pbuAhIx9yE2zwRo97rTcHGLzAnrJnbrf1fjkhlJ0qFk=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj67FGKipTFMqr7vbOLouBGnvBW4T5lL281Bsb2
 MeT+8OUEI6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+uxRgAKCRD2t4JPQmmg
 c5CHD/0XLS478ViEGLXstLJLS/TgUp/i1F33SDHjuM0V1mOCiHQgbMIyP67yF1Qgqzins95JjKM
 eI0IMUn7EtbL+QZSB8PZX4xo+szL/EkS2bi9JbP3GxyV2nRiXnSWeTJp4oXOsIzOrGjoRIlGkkd
 bidEeR8gAUTAxrQnwQLLX11jiqTVbICl4op54VGKQbDMGPBe5cMNtGJr4JHGMTvtxA2vV2DUTxI
 CIZ6TvQocUcSVailPhgMeenlBvc6hneSXQ9KBMgAKEUMusLNUR60/VcaH+R38Z+XNyshWBuTU/d
 oA/NXOHjpoWGld/T/n66/JBgDM06+3YBk1MsneI+6v/eHiN2Y901d2cdP8ZvlF7MvTsLAf7COWd
 cwBP/NxslP0xAT+m4bPovPNiDSY1yc25dlJr6ficIQasTduk27V3OjSzihz5XhLX1cwhwDlQA1V
 TD7gLC2NNPfe5Fkh4Tzv0PglRkHHGF91AUctI1GzDT+wEZSmdQsHeJdwlJ61NFNlIuhrfPa5jmU
 xuR5N5PubruEJOpod7LuNFhsRaXOjWP6vRcTMuz3TN5WE+GH5mqekDd1Eq1Tzm0TucIMXdjg6mR
 ZfsxPAuTneLQx8ePKqzxVqiUxoDHGurUWQy5g8Y/AMA+OtZ/1WkWROiDd5BWJrTYnhuQZOlLyYu
 kl73EZksHOOqVlw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Here are two MPTCP patches backports (patches 2-3/4), and one
prerequisite (patch 1/4), that recently failed to apply to the 6.1
stable tree. They prevent some locking issues with MPTCP.

After having cherry-picked patch 1/4 -- a simple refactoring to make a
function more generic -- patch 2/4 applied without any issue.

For patch 3/4, I had to resolve two simple function because two
if-statements around the modified code have curly braces in v6.1, not
later, see commit 976d302fb616 ("mptcp: deduplicate error paths on
endpoint creation").

On top of that, patch 4/4 fixes MPTCP userspace PM selftest that has
been recently broken due to a backport done in v6.1.8.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Matthieu Baerts (2):
      mptcp: sockopt: make 'tcp_fastopen_connect' generic
      selftests: mptcp: userspace: fix v4-v6 test in v6.1

Paolo Abeni (2):
      mptcp: fix locking for setsockopt corner-case
      mptcp: fix locking for in-kernel listener creation

 net/mptcp/pm_netlink.c                            | 10 ++++++----
 net/mptcp/sockopt.c                               | 20 ++++++++++++++------
 net/mptcp/subflow.c                               |  2 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 11 +++++++++++
 4 files changed, 32 insertions(+), 11 deletions(-)
---
base-commit: 9012d1ebd3236e1d741ab4264f1d14e276c2e29f
change-id: 20230214-upstream-stable-20230214-linux-6-1-12-rc1-mptcp-fixes-df24a5f41151

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

