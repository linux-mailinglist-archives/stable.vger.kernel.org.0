Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179694B86CA
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 12:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiBPLfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 06:35:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiBPLfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 06:35:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DA51CC513
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 03:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645011299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=DDTIzPaF0mXRzMtVEDgSBEg8dWyhguWOFXkGJLZe+Vo=;
        b=gyq22vzH4efBtJY5wAJ0blpO+WQ7y9nD/zJptD1ueXrRHXvZdZ/pssS/Pfb21GRuQCHbCa
        5HrD+Q3qKrJk9B0yJUZQWXMQ3HwANPX80SPNhZrdgXD+FYjat2C3zrfWQIWy6aoiyg8Ypy
        Va6x5euLeJyUU+/h3H82R0C3w8lG+IU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-HJMzF9R5ODeUgx9nmBAx9w-1; Wed, 16 Feb 2022 06:34:57 -0500
X-MC-Unique: HJMzF9R5ODeUgx9nmBAx9w-1
Received: by mail-wm1-f70.google.com with SMTP id 22-20020a05600c229600b0037be079ebf6so156950wmf.9
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 03:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DDTIzPaF0mXRzMtVEDgSBEg8dWyhguWOFXkGJLZe+Vo=;
        b=QwFT+SNWkbnGAqjkn5JTpQo5CeOL3cQttggqAadLZLIVCxdgRHEfp+/tiBVqYiQgwi
         kyq75PZpMttNc74PlHdy4xDPqwIAWyaiSMVYFGI/Hbnkun5hldPuSWU0c47Wdf/boruX
         KLHhhb7DTLXfKJx/SOqI9OUyhVmnDQybDYORD4nOJaqMQMzI5gjGslzcg9/p3ifKNw1P
         x6aASbB/7qbUPYGkspPfoBxumJlOSBJUjdxNQPZn5Je2tqYvWhKT28p3CDFAklKgexpP
         GAVy3RKi8LBy82iXTS9NorhsV5I+4dG5zXhCHs5G7tShFfvnxu51r0/zcriQeL5otG4h
         6f7A==
X-Gm-Message-State: AOAM532OvRttftgwm607vDj/GI2+44E1/aNW/4FJ7okPjle9XRwUODCl
        U0mfdwklf1okOPbDFzpL5cd5/v0C/7I7flD/JnOR/vHhGWJMJ2fMbE9yU1AEPxyxgX7FMIA8JhG
        FPNd1+zlplXlNyp/GVd6m4gx4GPv6rMol
X-Received: by 2002:a05:600c:1d99:b0:37b:b813:c7aa with SMTP id p25-20020a05600c1d9900b0037bb813c7aamr1223729wms.108.1645011296405;
        Wed, 16 Feb 2022 03:34:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx58L1MmfW7/AKfk0e5on6F+ATx5w6f8LcWeveGjlMsm230W5tSUYCf9AC2lkbiS0ZCAkkJY6+WOgcJuHOBRTw=
X-Received: by 2002:a05:600c:1d99:b0:37b:b813:c7aa with SMTP id
 p25-20020a05600c1d9900b0037bb813c7aamr1223714wms.108.1645011296183; Wed, 16
 Feb 2022 03:34:56 -0800 (PST)
MIME-Version: 1.0
From:   Karol Herbst <kherbst@redhat.com>
Date:   Wed, 16 Feb 2022 12:34:45 +0100
Message-ID: <CACO55tsiiuhuTFiTqFO4bqjex87AiMN4q18ovCFSF=+HW9uT9A@mail.gmail.com>
Subject: Backport request: drm/nouveau/pmu/gm200-: use alternate falcon reset sequence
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

subject: drm/nouveau/pmu/gm200-: use alternate falcon reset sequence
commit id: 4cdd2450bf739bada353e82d27b00db9af8c3001
kernels: 5.16 5.15 and 5.10

1d2271d2fb85e54bfc9630a6c30ac0feb9ffb983 got backported to a bunch of
kernel versions, which wasn't really intentional from nouveaus side. I
assume this happened because autosel picked it up due to the
"Reported-by" tag? Anyway, It actually requires
4cdd2450bf739bada353e82d27b00db9af8c3001 as well in order to not
regress systems. One bug report can be found here:
https://gitlab.freedesktop.org/drm/nouveau/-/issues/149

Users did test that applying 4cdd2450bf739bada353e82d27b00db9af8c3001
on top fixes the problems.

We still want to figure out what to do with 5.4 and older, because the
fix doesn't apply there, so we will either request a revert or send
modified patches.

Thanks

