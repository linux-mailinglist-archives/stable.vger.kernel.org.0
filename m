Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00066016EB
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJQTIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJQTII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD725FF6E
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 12:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666033685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilwCj0pj+SOs8iCCQ1o/T1oYMlaK8E4LhEeUqd7n7xM=;
        b=NW5Pge8Xl1kI1Uh/4rO8MjPYu02pAnzSkLCvJnPTHK6cn90urCppN5DKnD/jIo8DPbPLlK
        aoumDxyUWxHaYjU0RmIdrvumPXqSkthexcs9aR/X8Vn7PTLlIAGFQGy5OxkMFTbh8mxx3D
        Z7EwyOOJLg6cwiqsKnA3MHJ1WZ9A4fg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-08qL-U6sPxyLsqbbHsmL4g-1; Mon, 17 Oct 2022 15:08:04 -0400
X-MC-Unique: 08qL-U6sPxyLsqbbHsmL4g-1
Received: by mail-qt1-f198.google.com with SMTP id f19-20020ac84713000000b00397692bdaecso9216494qtp.22
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 12:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ilwCj0pj+SOs8iCCQ1o/T1oYMlaK8E4LhEeUqd7n7xM=;
        b=Y/shH/D0QKq11/poFoQFd9OQ7/pt1q+Re5O2HN+A82bhs+i/NceUaUg/BbfJmKGGQZ
         pETGiFn37p0UWmqruLpCxKgPGv462NmEg+tSKHJoIZG9sPbjmj4qJPqNbMcUqNal2hZv
         YckGq8Ee2U6gfwdR0ckU8NDnGnNqylIpnhi4nLY5+0roEBNdOjoYLKDkO6Y7En+XZguF
         qV/wXzoav+SrDjjlAg3JyqHeFsukWK1U65ZIJX4djp/8ASfltil/wF92BX15wiRwBSbc
         /kEkO/RkVHO2K7QqUNMEVSFdu+kh2KyTMGFVmVTV1gzg3TZ+g25oKhRIAYyezhEyZ0JT
         Ozqw==
X-Gm-Message-State: ACrzQf1Lp54kyx98ZFo6qrlBaR47Xsb6bs586bUwtsxUbDKAvISDjd87
        D49Lg9zqtTnMB+gGJ9JtsIlNb1gq6DzvbQQZMAMD4HrMOhGPwbnBMmRqJZ3rhHhqXN6AfaZz3M4
        ilqobr5lpfnnXPTjL
X-Received: by 2002:a05:622a:302:b0:39c:dc1f:db98 with SMTP id q2-20020a05622a030200b0039cdc1fdb98mr10226136qtw.467.1666033683377;
        Mon, 17 Oct 2022 12:08:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM76UvvScj47R2ZY2DxcytExeFmf9uLvqJju8KYn5YNtfF734a6NCoaPe+3Xtd00B4VrB5TRVQ==
X-Received: by 2002:a05:622a:302:b0:39c:dc1f:db98 with SMTP id q2-20020a05622a030200b0039cdc1fdb98mr10226114qtw.467.1666033683148;
        Mon, 17 Oct 2022 12:08:03 -0700 (PDT)
Received: from ?IPv6:2600:4040:5c68:4300::feb? ([2600:4040:5c68:4300::feb])
        by smtp.gmail.com with ESMTPSA id de38-20020a05620a372600b006ce30a5f892sm439488qkb.102.2022.10.17.12.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 12:08:02 -0700 (PDT)
Message-ID: <dd44a67411f0fc9065001696f231132ad85d9597.camel@redhat.com>
Subject: Re: [PATCH 2/2] drm/connector: send hotplug uevent on connector
 cleanup
From:   Lyude Paul <lyude@redhat.com>
To:     Simon Ser <contact@emersion.fr>, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jonas =?ISO-8859-1?Q?=C5dahl?= <jadahl@redhat.com>
Date:   Mon, 17 Oct 2022 15:08:01 -0400
In-Reply-To: <20221017153150.60675-2-contact@emersion.fr>
References: <20221017153150.60675-1-contact@emersion.fr>
         <20221017153150.60675-2-contact@emersion.fr>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LGTM! Thank you for the help with this:

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Mon, 2022-10-17 at 15:32 +0000, Simon Ser wrote:
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
> ---
>  drivers/gpu/drm/drm_connector.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
> index e3142c8142b3..90dad87e9ad0 100644
> --- a/drivers/gpu/drm/drm_connector.c
> +++ b/drivers/gpu/drm/drm_connector.c
> @@ -582,6 +582,9 @@ void drm_connector_cleanup(struct drm_connector *connector)
>  	mutex_destroy(&connector->mutex);
>  
>  	memset(connector, 0, sizeof(*connector));
> +
> +	if (dev->registered)
> +		drm_sysfs_hotplug_event(dev);
>  }
>  EXPORT_SYMBOL(drm_connector_cleanup);
>  

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

