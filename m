Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F502C4705
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgKYRsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 12:48:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731403AbgKYRsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 12:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606326510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPAlub6Lu18QJG/UwISztnXC7vpMcA+ULhrhJ2wogtA=;
        b=BfgVK9PXqi120nwx9m8e9zfj52wW2XoEmV+GcUmyryj0lFVa6bi99jL6NYZMQPyB3n0DmC
        w/aootUi/JhaNVi+UIq953TYKNEPnjWyo4y+0eA6Tk1Z5gTCSQ6O+iMEh2HMM5SVE1YgrM
        9HzPVKlaL8LcyZZC2mqmll9dovt3tSQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-PDByMXDqMHySHqBtL1uliQ-1; Wed, 25 Nov 2020 12:48:25 -0500
X-MC-Unique: PDByMXDqMHySHqBtL1uliQ-1
Received: by mail-ed1-f71.google.com with SMTP id b13so1362027edy.8
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 09:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PPAlub6Lu18QJG/UwISztnXC7vpMcA+ULhrhJ2wogtA=;
        b=JPxqYPCpZePwP4Umg5Vtc8oujt8oJlMVXPuvdxZOZ/RF4KTlZw9IJoH8jQuJeYRt8Y
         MArxuzdOQhknUsUkk9hUTmhbAzG0U4y+qavFgi/DAgqkD6hyafr/eTXWx5nDKTIN1hFA
         FPFGpquMq47q8feIBHDErc+sligKPMZaNYX20NNg2+/Y4oybqpqJScRHABTAhNyE6oat
         jqjydWmbXrg/Y2JouKpK/MEzwcuRAW2fgUJzmgp2LbtvYTVCn2grEeCcKhP+qW6HnSQ3
         dclN3rYepIyZVxTBAA6HFjWLCTOcFYyo4qPzsDV3x4HZryzMq7POCyGG3SW8mXZgvC7Y
         DaQQ==
X-Gm-Message-State: AOAM5328AeSj08hGu/ClOrlK2zQxxX2hfHbmxCSfZVBvYPJ0xGdG6UhK
        JN0UfjtxgCcwAtDcUyEiQcw/OTnicAirGDPFX7RYLPckAy2B1YSp/sQIhM3gntwvvkMoCfNIpas
        NCbJv9R3lz1yreWjq
X-Received: by 2002:a17:906:38db:: with SMTP id r27mr4168631ejd.328.1606326503976;
        Wed, 25 Nov 2020 09:48:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxr2gVh9P7XRmeTfb7uFaE+EScbcdMKxEjEz+ho32BWcP+21n+ieNOFuJ/XNTV98wqLH5Q7Cg==
X-Received: by 2002:a17:906:38db:: with SMTP id r27mr4168614ejd.328.1606326503716;
        Wed, 25 Nov 2020 09:48:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mj17sm1659943ejb.59.2020.11.25.09.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 09:48:22 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
Date:   Wed, 25 Nov 2020 18:48:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201125153550.810101-22-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/11/20 16:35, Sasha Levin wrote:
> From: Mike Christie <michael.christie@oracle.com>
> 
> [ Upstream commit 18f1becb6948cd411fd01968a0a54af63732e73c ]
> 
> Move code to parse lun from req's lun_buf to helper, so tmf code
> can use it in the next patch.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Link: https://lore.kernel.org/r/1604986403-4931-5-git-send-email-michael.christie@oracle.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This doesn't seem like stable material, does it?

Paolo

> ---
>   drivers/vhost/scsi.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 5d8850f5aef16..ed7dc6b998f65 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -898,6 +898,11 @@ vhost_scsi_get_req(struct vhost_virtqueue *vq, struct vhost_scsi_ctx *vc,
>   	return ret;
>   }
>   
> +static u16 vhost_buf_to_lun(u8 *lun_buf)
> +{
> +	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
> +}
> +
>   static void
>   vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>   {
> @@ -1036,12 +1041,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>   			tag = vhost64_to_cpu(vq, v_req_pi.tag);
>   			task_attr = v_req_pi.task_attr;
>   			cdb = &v_req_pi.cdb[0];
> -			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req_pi.lun);
>   		} else {
>   			tag = vhost64_to_cpu(vq, v_req.tag);
>   			task_attr = v_req.task_attr;
>   			cdb = &v_req.cdb[0];
> -			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req.lun);
>   		}
>   		/*
>   		 * Check that the received CDB size does not exceeded our
> 

