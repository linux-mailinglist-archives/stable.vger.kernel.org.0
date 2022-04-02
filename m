Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDDC4F001E
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiDBJc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 05:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiDBJc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 05:32:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B78E31C108
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 02:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648891833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HGzlFg5+VxJDfdKA7pBklnbv9/mJ/ipyxQ5DChKwQfg=;
        b=MAnepPFi8u53bwNbIG1YkCZi3grwHFtOmM5RgU3monx5ARdFIGQsszNGzDhhXC04p7WOaG
        EGBWaFS1aKm6PC7rwSG8JowHaLDmaJDwvf2I7Uy8+SG8iu1DN6RKD3BXorM06ymF5XAPRP
        LiPkdoRtWr37NIret0jxDXK/OEJK1C4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-3J_BXvHeNdKGnEcNfYzkug-1; Sat, 02 Apr 2022 05:30:31 -0400
X-MC-Unique: 3J_BXvHeNdKGnEcNfYzkug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D8191C05AB1;
        Sat,  2 Apr 2022 09:30:31 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.192.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E27610EB0;
        Sat,  2 Apr 2022 09:30:30 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH 0/1] drm/simpledrm: Add "panel orientation" property on non-upright mounted LCD panels
Date:   Sat,  2 Apr 2022 11:30:28 +0200
Message-Id: <20220402093029.5334-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Fedora 36 has switched from efifb to simpledrm as the pre-native-GPU driver
fb provider and the lack of this patch is causing issues for devices with
non up-right mounted LCD panels (1), can you please add this to the 5.17 stable
series?

Regards,

Hans

1) https://bugzilla.redhat.com/show_bug.cgi?id=2071134


Hans de Goede (1):
  drm/simpledrm: Add "panel orientation" property on non-upright mounted
    LCD panels

 drivers/gpu/drm/tiny/simpledrm.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
2.35.1

