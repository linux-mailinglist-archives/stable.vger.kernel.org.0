Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552ED1C43AF
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgEDSAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731030AbgEDSAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 14:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588615238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ekvQ0W9+R32qHNFUdIvIRrUfmozi/8YjzI602DYnNY=;
        b=EBBoBJFHWdeFtH4gGvTw8EcbopGnzdRZ8ZYg44SM60QV8PeVnNE275WVUKXCbbhz1LOiBa
        n2aF2docrICQwajbHwXmyzgYG2oCYN07YCiXzY79uQb1mYLSDZ3ixm+Tb+vxpZq9i4Tpld
        kKc1ID9ys+6z0HiZN2lNzVZdvT2GKXU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-exhkHmypMVa8gj7tlbS9Vw-1; Mon, 04 May 2020 14:00:34 -0400
X-MC-Unique: exhkHmypMVa8gj7tlbS9Vw-1
Received: by mail-qt1-f200.google.com with SMTP id u13so421695qtk.5
        for <stable@vger.kernel.org>; Mon, 04 May 2020 11:00:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ekvQ0W9+R32qHNFUdIvIRrUfmozi/8YjzI602DYnNY=;
        b=YcWfOisOO/iYa+X/Ge3sPyBX9RU1V3zxDg4yp/60vOW8zIQZ4ahK4bh3wf1WhCh3TG
         YKmD+4v36cnLWmmuaoEOgLTmanp01BEWVwswaDUoPZsLg6UEhZLkh94K8hT3H0q6BplI
         uO2eoq95e/mYoYOuKrcp6xWCB5j0Oa7hRuYdmjhG4knj+Tti4Ubirz3z6iNTJHZVFB+P
         IyNC1v+PQFEzH8ymxqtOzTPlFxuLqQ8LBHiANuT4lTlVmIC54OB7nMTiCULj4VvuhHi3
         TBediTqqrqKLT5BLEZshr4woGQpo3L2O7jfdRrx5NGVX/xWbC6VN0bCWCEoR+97wO2xA
         UItQ==
X-Gm-Message-State: AGi0Pub4U5MnMDMjv1JxG6aHj62H3QaJEApVSYWS0TSu9/6kYli5xyS/
        9GMVIxlIxMHSYOrTRMGm9boPaI/qytTxsBZwJyZCrpeymXfoXH9coHUj+L9brcGB3tv03nMun0J
        1fnBl4V3eDZwnt6z/
X-Received: by 2002:a37:7ac2:: with SMTP id v185mr420382qkc.386.1588615234040;
        Mon, 04 May 2020 11:00:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypKnPZqN9nanSFOcjxGdXzeO8UeX54jnQMDIyTHF0H8gUXHreTJ/6vLH9+V/+wddz6hIGwk4aA==
X-Received: by 2002:a37:7ac2:: with SMTP id v185mr420356qkc.386.1588615233715;
        Mon, 04 May 2020 11:00:33 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id d4sm11755419qtc.48.2020.05.04.11.00.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 11:00:33 -0700 (PDT)
Message-ID: <f42a7ef6701574ebe4805a494650c56a10a9bdae.camel@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx: Do not log message when reading port
 speed via sysfs
From:   Laurence Oberman <loberman@redhat.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com,
        himanshu.madhani@oracle.com
Date:   Mon, 04 May 2020 14:00:32 -0400
In-Reply-To: <20200504175416.15417-1-emilne@redhat.com>
References: <20200504175416.15417-1-emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-05-04 at 13:54 -0400, Ewan D. Milne wrote:
> Calling ql_log() inside qla2x00_port_speed_show() is causing messages
> to be output to the console for no particularly good reason.  The
> sysfs
> read routine should just return the information to userspace.  The
> only
> reason to log a message is when the port speed actually changes, and
> this already occurs elsewhere.
> 
> Cc: <stable@vger.kernel.org> # v5.1+
> Fixes: 4910b524ac9 ("scsi: qla2xxx: Add support for setting port
> speed")
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 3325596..2c9e5ac 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1850,9 +1850,6 @@ qla2x00_port_speed_show(struct device *dev,
> struct device_attribute *attr,
>  		return -EINVAL;
>  	}
>  
> -	ql_log(ql_log_info, vha, 0x70d6,
> -	    "port speed:%d\n", ha->link_data_rate);
> -
>  	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha-
> >link_data_rate]);
>  }
>  

Looks good for me, and fixes an issue we dealt with last week. 
In other words confusing log noise for customers.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

