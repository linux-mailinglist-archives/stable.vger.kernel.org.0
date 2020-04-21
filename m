Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1FB1B2E7C
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgDURll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:41:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49583 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDURlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:41:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CBFF75C010B;
        Tue, 21 Apr 2020 13:41:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=c6NUfIcL8iEd3sc6cWM51EfZOhT
        g3PneqfBlYaWah6A=; b=d0zRglxzWfSBxl7kaZjRHxl255hrRjrz/RJOSOx+Ph2
        0LODjWzcQMw2mFND43GG3al+2qfvMhSJ7yB10VV+RQ+AxkxcLbS+LzVlsndEvsEK
        JE/d5MeTFDfdzwe82ZkHzj7DO6opX96cA7QAVsmIUw9Tbvl7wFnGwh/iCVAAA1Bz
        dwCLiQ2WYJWXJwUfzx3rduQ5C9VaQaWPudwPs2R/g69zxx+BnHutjFlumwOf5rZg
        QjBGXp733Sz1LC61NBRRez0F7yp90XZ50fNLdtQwQyOGazAe9jrkDHAArkopTFuT
        b3Gg0rUXPmBnJOiy5hoKIKc3c4x6duTOnJfT1YV1w4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=c6NUfI
        cL8iEd3sc6cWM51EfZOhTg3PneqfBlYaWah6A=; b=3RMhhTQT7XjQ66rKUVAc7U
        Q9B2HLMs5BAKp+BfBXc6MRWCNdJJ1dtcVt8I+zYMGHa/K8ZHSKo08BGbE+/gX8Es
        Df1PUuFxf8MN8rbR6+dBaH6mf7IWmPPjozhp62vJxG5oNeCJQx4hdyQ2dscY27Rm
        m2tlVtZ2hsoyW8CJPJRMkkNW9nSfNY608VsxVhh8RScq3aSwxGGTMYAojPEhgpVy
        UJA5/CxMz+5ux4AViNGDthnLyJGg3UMV8GDl0lSvkCtRZ9/250XUV7vcaf5CzLiP
        KtMR3h8a9qd/IfcSFJF1JqwpF9z6EszJlFbrZE9WKHg38ELw0r51LmV9oqRGp6MA
        ==
X-ME-Sender: <xms:UjCfXgOISA6GL9gTgUF_e2XyLxz1qL3szqF_48FCf1KjMvNS-dH96Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UjCfXsVGYS4ImVkJ4WpCHuj3C0cEYl2CpcUeMg8DX-PoxVT3OedJUA>
    <xmx:UjCfXq6a8bE24gf2cKbhtgmBzOuILJ9mvt-xlcKZHjSkJP0K3PKarA>
    <xmx:UjCfXompH5oGJEvvr1Lcxmds4vzf5Uc3pwZ6tEc51Mz1Yi_V0wZ0DA>
    <xmx:UjCfXhmmbbfO9Xrv7_43PLsjK5PpvVPEm6-HMIpJcjt97ZvX4bTIcw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53B6E3065C88;
        Tue, 21 Apr 2020 13:41:38 -0400 (EDT)
Date:   Tue, 21 Apr 2020 19:41:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.14 15/24] net: qualcomm: rmnet: Fix casting issues
Message-ID: <20200421174136.GB1307291@kroah.com>
References: <20200421124017.272694-1-lee.jones@linaro.org>
 <20200421124017.272694-16-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421124017.272694-16-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 01:40:08PM +0100, Lee Jones wrote:
> From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> 
> [ Upstream commit 6e010dd9b16b1a320bbf8312359ac294d7e1d9a8 ]
> 
> Fix warnings which were reported when running with sparse
> (make C=1 CF=-D__CHECK_ENDIAN__)
> 
> drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:81:15:
> warning: cast to restricted __be16
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:271:37:
> warning: incorrect type in assignment (different base types)
> expected unsigned short [unsigned] [usertype] pkt_len
> got restricted __be16 [usertype] <noident>
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:287:29:
> warning: incorrect type in assignment (different base types)
> expected unsigned short [unsigned] [usertype] pkt_len
> got restricted __be16 [usertype] <noident>
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:310:22:
> warning: cast to restricted __be16
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:319:13:
> warning: cast to restricted __be16
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:49:18:
> warning: cast to restricted __be16
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:50:18:
> warning: cast to restricted __be32
> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c:74:21:
> warning: cast to restricted __be16
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> index ce2302c25b128..41fa881e4540e 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
> @@ -23,8 +23,8 @@ struct rmnet_map_control_command {
>  		struct {
>  			u16 ip_family:2;
>  			u16 reserved:14;
> -			u16 flow_control_seq_num;
> -			u32 qos_id;
> +			__be16 flow_control_seq_num;
> +			__be32 qos_id;
>  		} flow_control;
>  		u8 data[0];
>  	};
> @@ -53,7 +53,7 @@ struct rmnet_map_header {
>  	u8  reserved_bit:1;
>  	u8  cd_bit:1;
>  	u8  mux_id;
> -	u16 pkt_len;
> +	__be16 pkt_len;

Again, a nice patch, but doesn't actually fix a bug, so not needed for
stable.

thanks,

greg k-h
