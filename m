Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAECF44521E
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 12:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhKDLZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 07:25:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42160 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKDLZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 07:25:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A41CF212B9;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636024999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=evOMX7cbEkDR/o8ta2rBo1OwmCvh8o3E/C1B63SxNqs=;
        b=TWXna85w+gdshlD7/bxhk7vO/1EeDxsS06p+VKO7s6oUoSKWwRTYX2mAcKDM4lv/cxAQ77
        dy1F5rNwOZVkZq5j1DPeXf3GtHGijGFG4kklCadiKtJjfs4pFxKNFYPg6iJlomhu57nhRR
        /FcILp4lWp0YKoVg9NdYjr7E9iIAL74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636024999;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=evOMX7cbEkDR/o8ta2rBo1OwmCvh8o3E/C1B63SxNqs=;
        b=eXlEwzW6jXLcJCSx5TWoV/3/apPYn0k3sjM7hQd0oyXRws+sMHQczv4jmuSpTFnNn6hmfI
        GuS5WRyki0v8jwBg==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 8E3D22C144;
        Thu,  4 Nov 2021 11:23:19 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.14.y 0/2] Two USB-audio backported patches
Date:   Thu,  4 Nov 2021 12:23:07 +0100
Message-Id: <20211104112309.30984-1-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

here are two trivial USB-audio patches I adapted the upstream commits
for the older kernels up to 5.14.y.  Feel free cherry-pick to 5.10.y
and older trees as long as applicable.


thanks,

Takashi

===

Takashi Iwai (2):
  ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
  ALSA: usb-audio: Add Audient iD14 to mixer map quirk table

 sound/usb/mixer_maps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.31.1

