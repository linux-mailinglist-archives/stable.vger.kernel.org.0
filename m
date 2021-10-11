Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1994290D7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhJKOM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239963AbhJKOK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E5361252;
        Mon, 11 Oct 2021 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960971;
        bh=9SCEJEaOxIZrtiA6HoCueS51aqQqInjcple+irKMXTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLgulsobcNr6w46iCWwSeQ4Yv7whhRrlK3XxYBECv3d2ozKjfMJlu1d1bInAIJcnP
         53zvNlTjglxEFOq3Hf2QM1H65mCMwP5Jowrimz7G3G3Dy6/MWJjlql1DsSfTM8dlNh
         KuEMoGumyAspdy99PLCjA6YHWTorXu9KQlHsDfyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/151] i2c: mlxcpld: Modify register setting for 400KHz frequency
Date:   Mon, 11 Oct 2021 15:46:40 +0200
Message-Id: <20211011134521.945494471@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit fa1049135c15b4930ce7ea757a81b1b78908f304 ]

Change setting for 400KHz frequency support by more accurate value.

Fixes: 66b0c2846ba8 ("i2c: mlxcpld: Add support for I2C bus frequency setting")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxcpld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 6d41c3db8a2b..015e11c4663f 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -49,7 +49,7 @@
 #define MLXCPLD_LPCI2C_NACK_IND		2
 
 #define MLXCPLD_I2C_FREQ_1000KHZ_SET	0x04
-#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0f
+#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0c
 #define MLXCPLD_I2C_FREQ_100KHZ_SET	0x42
 
 enum mlxcpld_i2c_frequency {
-- 
2.33.0



