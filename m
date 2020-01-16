Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1C13DFFE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgAPQYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:24:44 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36414 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAPQYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:24:44 -0500
Received: by mail-qv1-f65.google.com with SMTP id m14so9310523qvl.3
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 08:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zcln8NCtutclseccFrN+kIHmERpcKgzVFUpuz3yzSV0=;
        b=cRzuaOaLrE1KgOjTd5jG3GJxdMW2GqpXLMQHkFDRI5FmjnCc2SVf1aXBSvFNL/rUaf
         HnXtWsp6j6j9jd9RGojkYQyFgiLaU6vwzdJ2UtYmdUaluWQDhVsxFiWhKuOiI3AxwJ4+
         4iuAkiHtBf7D3YEKVJjHAYLZ7i8H2E+cV1ymZMpblTdq06BfO6I456tPO4eADf/+myhg
         IFe4uAfQsrblfLzrtouHrYnHpahErEOmaVmBVtd8JdsH7TXPXjPQ1Y6w3+C8ML50iTzu
         fpcn+iGhDqLriDSVBoOk9Ke4+Q7vxV6Yqg/jLDV9/QEs6GAk/938ETMXQQlcE5xI0yih
         yHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zcln8NCtutclseccFrN+kIHmERpcKgzVFUpuz3yzSV0=;
        b=KMZFkSDB25bOK6tbdMWjhyzH26HkcUY3ouM/MZwF/nGDAqS7SbW5cb+/0QhRlQqOn6
         LwVrSGH9JSOo5BfhnaRqM31s+UlR58fdwSxTxUx1pRrDBkrpgOOHnweiFTOMMytcGkOe
         fHC9wxQi4zIl2Qmp8emQc5DIh+XwuZpyy/Iqg16CZzaqXOrA7CziuRZ42Z/GvmS3/vvG
         AZUHYAXepl0ftQZVQySralAOprkXW9mNpbQ9BMel5mQCg1QuPRc2bPFFfWy4KhoweRKu
         Zb3ISiGtclSJ5zgf2mPxT2VLT02rqeIeMT9EPgGwqfy2Z0syoEY0nzhKQajzHbOqCnaL
         UZpQ==
X-Gm-Message-State: APjAAAX+RWKFXazNfqI08BjV71Nc8EPy8S/+AD+Pm58OovNhIU3YECww
        mXEPBgZ09VPqdD5rgydAYqGKmvVB
X-Google-Smtp-Source: APXvYqw2YWiSNayTNmGDaPrfQBKiQMQKd28ErM/WZ1qkJrylyfbBW6/HcWZboyRXteDUCCtizTc5Nw==
X-Received: by 2002:ad4:5a53:: with SMTP id ej19mr3431532qvb.34.1579191882842;
        Thu, 16 Jan 2020 08:24:42 -0800 (PST)
Received: from localhost.localdomain ([71.219.59.120])
        by smtp.gmail.com with ESMTPSA id 4sm10241850qki.51.2020.01.16.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:24:42 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 0/2] Fixes for navi14 in kernel 5.4
Date:   Thu, 16 Jan 2020 11:24:27 -0500
Message-Id: <20200116162429.4000-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

These patches fix hangs on boot with some navi14 boards in
kernel 5.4.  These patches are cherry-picked from 5.5.

Please apply.

Thanks,

Alex

Christian König (1):
  drm/amdgpu: cleanup creating BOs at fixed location (v2)

Xiaojie Yuan (1):
  drm/amdgpu/discovery: reserve discovery data at the top of VRAM

 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h |  2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c    | 61 ++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h    |  3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c       | 85 ++--------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       | 99 ++++++-------------
 drivers/gpu/drm/amd/include/discovery.h       |  1 -
 8 files changed, 105 insertions(+), 151 deletions(-)

-- 
2.24.1

