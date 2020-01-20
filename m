Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B31142E45
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 16:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgATPFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 10:05:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:38825 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgATPFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 10:05:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jan 2020 07:05:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,342,1574150400"; 
   d="scan'208";a="275590165"
Received: from kuha.fi.intel.com ([10.237.72.53])
  by fmsmga001.fm.intel.com with SMTP; 20 Jan 2020 07:05:11 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 20 Jan 2020 17:05:11 +0200
Date:   Mon, 20 Jan 2020 17:05:11 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Thomas Hebb <tommyhebb@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/2] usb: typec: wcove: fix "op-sink-microwatt"
 default that was in mW
Message-ID: <20200120150511.GG32175@kuha.fi.intel.com>
References: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 20, 2020 at 06:09:05AM -0800, Thomas Hebb wrote:
> commit 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
> didn't convert this value from mW to uW when migrating to a new
> specification format like it should have.
> 
> Fixes: 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> 
> Changes in v3:
> - Use the right stable email address
> 
> Changes in v2:
> - Split fix into two patches
> - Added stable cc
> 
>  drivers/usb/typec/tcpm/wcove.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/wcove.c b/drivers/usb/typec/tcpm/wcove.c
> index edc271da14f4..9b745f432c91 100644
> --- a/drivers/usb/typec/tcpm/wcove.c
> +++ b/drivers/usb/typec/tcpm/wcove.c
> @@ -597,7 +597,7 @@ static const struct property_entry wcove_props[] = {
>  	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
>  	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
>  	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
> -	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000),
> +	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000000),
>  	{ }
>  };
>  
> -- 
> 2.24.1

thanks,

-- 
heikki
