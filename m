Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED4233AEF
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 23:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgG3Vkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 17:40:45 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.210]:24156 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728849AbgG3Vkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 17:40:43 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2020 17:40:41 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id BD7E7400D9BA1
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 16:19:03 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1Fx9kXaASRQIV1Fx9kwWfi; Thu, 30 Jul 2020 16:19:03 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dgc5q+btJ0qLtgKsOpVqoaxgoehsQ/cFQWUFMqbTx18=; b=Ya+aBj1VC2ibFEEbdFxjVK4+ip
        rkM8dXXAa/PREqZa0iuogOr01gjvLpHYNbssEGN/zkmWd4pg300hxGZ0YDV0vDczgw1tadrJZJdSB
        Byx0gprUPjOisZN+Wpgm5zMPDGyK0U2+xhvQQlaxnJQkq6PNZ1QFHYL3gzw9r2kZWDpi1r3f6qisT
        GNQ/APg1Jrn0/kjeBM+r96mqOz5ZU//dxn+DyJoeDQc1X1+eRv48XMv8zRj5I1I7OEB6+6VbjAQSp
        6aQA68ANDCl4ClGl8IBflmtaHXFtd13xAhDrr2suFC3OtuAcsFhsNo7poVTyxhyySxNpK4VdzfxEe
        69Pckl1g==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:47268 helo=[192.168.15.3])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1k1Fx7-000Sv2-Gr; Thu, 30 Jul 2020 16:19:01 -0500
To:     Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Ramalingam C <ramalingam.c@intel.com>, stable@vger.kernel.org
References: <20200730185451.3621108-1-tomas.winkler@intel.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 AP7RWS474w==
Subject: Re: [char-misc-next V3] mei: hdcp: fix mei_hdcp_verify_mprime() input
 paramter
Message-ID: <2ce86027-467f-6cc0-6e1b-f706dd1adfe5@embeddedor.com>
Date:   Thu, 30 Jul 2020 16:25:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200730185451.3621108-1-tomas.winkler@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1k1Fx7-000Sv2-Gr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.3]) [187.162.31.110]:47268
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tomas,

The subject line has a typo: s/paramter/parameter

Please, see more comments below...

On 7/30/20 13:54, Tomas Winkler wrote:
> wired_cmd_repeater_auth_stream_req_in has a variable
> length array at the end. we use struct_size() overflow
> macro to determine the size for the allocation and sending
> size.
> This also fixes bug in case number of streams is > 0 in the original
> submission. This bug was not triggered as the number of streams is
> always one.
> 
> Fixes: c56967d674e3 (mei: hdcp: Replace one-element array with flexible-array member)
> Fixes: 0a1af1b5c18d ("misc/mei/hdcp: Verify M_prime")
> Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> Cc: Ramalingam C <ramalingam.c@intel.com>
> Cc: <stable@vger.kernel.org> v5.1+
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V3:
> 1. Fix commit message with more info and another patch it fixes (Gustavo)
> 2. Target stable. (Gustavo)
> V2: Check for allocation failure.
>  drivers/misc/mei/hdcp/mei_hdcp.c | 40 +++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
> index d1d3e025ca0e..f1205e0060db 100644
> --- a/drivers/misc/mei/hdcp/mei_hdcp.c
> +++ b/drivers/misc/mei/hdcp/mei_hdcp.c
> @@ -546,38 +546,46 @@ static int mei_hdcp_verify_mprime(struct device *dev,
>  				  struct hdcp_port_data *data,
>  				  struct hdcp2_rep_stream_ready *stream_ready)
>  {
> -	struct wired_cmd_repeater_auth_stream_req_in
> -					verify_mprime_in = { { 0 } };
> +	struct wired_cmd_repeater_auth_stream_req_in *verify_mprime_in;
>  	struct wired_cmd_repeater_auth_stream_req_out
>  					verify_mprime_out = { { 0 } };
>  	struct mei_cl_device *cldev;
>  	ssize_t byte;
> +	size_t cmd_size;
>  
>  	if (!dev || !stream_ready || !data)
>  		return -EINVAL;
>  
>  	cldev = to_mei_cl_device(dev);
>  
> -	verify_mprime_in.header.api_version = HDCP_API_VERSION;
> -	verify_mprime_in.header.command_id = WIRED_REPEATER_AUTH_STREAM_REQ;
> -	verify_mprime_in.header.status = ME_HDCP_STATUS_SUCCESS;
> -	verify_mprime_in.header.buffer_len =
> +	cmd_size = struct_size(verify_mprime_in, streams, data->k);
> +	if (cmd_size == SIZE_MAX)
> +		return -EINVAL;
> +
> +	verify_mprime_in = kzalloc(cmd_size, GFP_KERNEL);
> +	if (!verify_mprime_in)
> +		return -ENOMEM;
> +
> +	verify_mprime_in->header.api_version = HDCP_API_VERSION;
> +	verify_mprime_in->header.command_id = WIRED_REPEATER_AUTH_STREAM_REQ;
> +	verify_mprime_in->header.status = ME_HDCP_STATUS_SUCCESS;
> +	verify_mprime_in->header.buffer_len =
>  			WIRED_CMD_BUF_LEN_REPEATER_AUTH_STREAM_REQ_MIN_IN;
>  
> -	verify_mprime_in.port.integrated_port_type = data->port_type;
> -	verify_mprime_in.port.physical_port = (u8)data->fw_ddi;
> -	verify_mprime_in.port.attached_transcoder = (u8)data->fw_tc;
> +	verify_mprime_in->port.integrated_port_type = data->port_type;
> +	verify_mprime_in->port.physical_port = (u8)data->fw_ddi;
> +	verify_mprime_in->port.attached_transcoder = (u8)data->fw_tc;
> +
> +	memcpy(verify_mprime_in->m_prime, stream_ready->m_prime, HDCP_2_2_MPRIME_LEN);
> +	drm_hdcp_cpu_to_be24(verify_mprime_in->seq_num_m, data->seq_num_m);
>  
> -	memcpy(verify_mprime_in.m_prime, stream_ready->m_prime,
> -	       HDCP_2_2_MPRIME_LEN);
> -	drm_hdcp_cpu_to_be24(verify_mprime_in.seq_num_m, data->seq_num_m);
> -	memcpy(verify_mprime_in.streams, data->streams,
> +	memcpy(verify_mprime_in->streams, data->streams,
>  	       array_size(data->k, sizeof(*data->streams)));
>  
> -	verify_mprime_in.k = cpu_to_be16(data->k);
> +	verify_mprime_in->k = cpu_to_be16(data->k);
>  
> -	byte = mei_cldev_send(cldev, (u8 *)&verify_mprime_in,
> -			      sizeof(verify_mprime_in));
> +	byte = mei_cldev_send(cldev, (u8 *)&verify_mprime_in, cmd_size);

The line above is incorrect, it should be this, instead:

byte = mei_cldev_send(cldev, (u8 *)verify_mprime_in, cmd_size);

otherwise you are passing the address of the object pointer
verify_mprime_in and not the reference to what it points to,
which is what we want in this case.

Thanks
--
Gustavo

> +	kfree(verify_mprime_in);
>  	if (byte < 0) {
>  		dev_dbg(dev, "mei_cldev_send failed. %zd\n", byte);
>  		return byte;
> 
