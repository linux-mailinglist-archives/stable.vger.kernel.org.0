Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4102737CB20
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbhELQel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241471AbhELQ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7767561DDE;
        Wed, 12 May 2021 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834784;
        bh=O7XhT6H2L7FDCaV0Ml4FZ3fVGjl3PcNFkEgSjz/5SUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyWOt1nTWHmtuWuwpoCWtbG13KiqbTlj7ftUNC8rhuo9D5JNO9ROu1mT1YISo54bW
         ITaeRWfJriDd1PqaLuY9FXeFUv/w6WjTAGwbz2axFcXFuIoh1QGY/57tcwP7IU4Yn+
         NPgcs58wV8QHwKIBIPDaDywr7yh6t5EJNIpvsGXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Zhao <Victor.Zhao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 083/677] drm/amdgpu: fix r initial values
Date:   Wed, 12 May 2021 16:42:09 +0200
Message-Id: <20210512144839.982144062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Zhao <Victor.Zhao@amd.com>

commit 4b12ee6f426e5e36396501a58f3a1af5b92a7e06 upstream.

Sriov gets suspend of IP block <dce_virtual> failed as return
value was not initialized.

v2: return 0 directly to align original code semantic before this
was broken out into a separate helper function instead of setting
initial values

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1355,7 +1355,7 @@ int amdgpu_display_suspend_helper(struct
 			}
 		}
 	}
-	return r;
+	return 0;
 }
 
 int amdgpu_display_resume_helper(struct amdgpu_device *adev)


