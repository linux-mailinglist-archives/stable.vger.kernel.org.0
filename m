Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EFB6012CB
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJQPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJQPet (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB23F12D34
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 08:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666020886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5Hw3N/yBRvXSb8kCKGLJA5iLp5ZJdPKFLyQnc+d2Vs=;
        b=U1FrnjWw5prz6irG6FshQ/87Y52T+Hgp/T86CQ919WBAaCAa7CY1PdAgksAVfKuDXEg/U+
        lgTO5qliPbVSC4BTD5vjZ2jN6I0nvXoBfDeyigmGUKJAYjIstWKPpjN4PIBru02Jm1pf6L
        g+AeT04ispUAMH+cqk6b0pBjI6R4UyI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-SDPW84E7Nb2Q2NRnQ72iyw-1; Mon, 17 Oct 2022 11:34:43 -0400
X-MC-Unique: SDPW84E7Nb2Q2NRnQ72iyw-1
Received: by mail-lf1-f70.google.com with SMTP id p36-20020a05651213a400b004779d806c13so3773882lfa.10
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 08:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N5Hw3N/yBRvXSb8kCKGLJA5iLp5ZJdPKFLyQnc+d2Vs=;
        b=UyDiu4tjbegyr4a2RYnfk6ztJCViJ+k7TYzYOiBlqlFsM2KOwbYNCJJOxeqEst6lZ+
         OiAoP27sUm1WrCJEYiyawSfJQHJ+ydwvL/qam0YYkh0tAwrypzKy2gW8ygqdxXEiajM4
         3ERiC087e7dH0Yigw0WNGy+Qq2RwciMlA5uGxr8UX/on7guI5E64TG8boE3IhFqtpMc8
         vj4KC465ZLK3Eto7PtYEx/UEk/LW1a8ahB/f729twMDKYh2bYubNpwAniz+jPb4PA+JP
         ygewVPA5XwXPw4sI6izCs03fUG69J5m4ndlSgKj11nTuzYFI4uBT2jHLDhxn+P3MBPo5
         5LZA==
X-Gm-Message-State: ACrzQf0Vnw3tGmefrTCEq3DmAS7oPVO40JY5EAXOevCdc/l5WzBnkOOd
        eDJjb3WWgo88F7v2+lBsUXD5ymCKmi7Q6h1p4AYPa0ZDNO/z/bVxkRV3irsVMHeHaq0uosiAz6M
        WPzIzNB94Iv5ye6xT
X-Received: by 2002:a05:651c:98f:b0:26d:ff18:97c6 with SMTP id b15-20020a05651c098f00b0026dff1897c6mr4533684ljq.375.1666020881549;
        Mon, 17 Oct 2022 08:34:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57wE364GqH9fWnoe0gYe9cPBp5F/31FMQZv9YAdTOl72+aEIDVZL9AQd9N6JQ0iPqlCe8DDA==
X-Received: by 2002:a05:651c:98f:b0:26d:ff18:97c6 with SMTP id b15-20020a05651c098f00b0026dff1897c6mr4533677ljq.375.1666020881356;
        Mon, 17 Oct 2022 08:34:41 -0700 (PDT)
Received: from redhat.com (host-90-235-3-243.mobileonline.telia.com. [90.235.3.243])
        by smtp.gmail.com with ESMTPSA id u4-20020a05651c140400b0026fbac7468bsm1490240lje.103.2022.10.17.08.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 08:34:39 -0700 (PDT)
Date:   Mon, 17 Oct 2022 17:34:37 +0200
From:   Jonas =?iso-8859-1?Q?=C5dahl?= <jadahl@redhat.com>
To:     Simon Ser <contact@emersion.fr>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lyude Paul <lyude@redhat.com>
Subject: Re: [PATCH 2/2] drm/connector: send hotplug uevent on connector
 cleanup
Message-ID: <Y012DW23jc11f2ZU@redhat.com>
References: <20221017153150.60675-1-contact@emersion.fr>
 <20221017153150.60675-2-contact@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221017153150.60675-2-contact@emersion.fr>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 03:32:01PM +0000, Simon Ser wrote:
> A typical DP-MST unplug removes a KMS connector. However care must
> be taken to properly synchronize with user-space. The expected
> sequence of events is the following:
> 
> 1. The kernel notices that the DP-MST port is gone.
> 2. The kernel marks the connector as disconnected, then sends a
>    uevent to make user-space re-scan the connector list.
> 3. User-space notices the connector goes from connected to disconnected,
>    disables it.
> 4. Kernel handles the the IOCTL disabling the connector. On success,
>    the very last reference to the struct drm_connector is dropped and
>    drm_connector_cleanup() is called.
> 5. The connector is removed from the list, and a uevent is sent to tell
>    user-space that the connector disappeared.
> 
> The very last step was missing. As a result, user-space thought the
> connector still existed and could try to disable it again. Since the
> kernel no longer knows about the connector, that would end up with
> EINVAL and confused user-space.
> 
> Fix this by sending a hotplug uevent from drm_connector_cleanup().
> 
> Signed-off-by: Simon Ser <contact@emersion.fr>
> Cc: stable@vger.kernel.org
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Jonas Ådahl <jadahl@redhat.com>

Tested-by: Jonas Ådahl <jadahl@redhat.com>


Jonas

