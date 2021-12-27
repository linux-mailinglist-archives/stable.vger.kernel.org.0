Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C8647FD40
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhL0NKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:10:12 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58923 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230148AbhL0NKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:10:12 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DBF955C02E7;
        Mon, 27 Dec 2021 08:10:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Dec 2021 08:10:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=FItMTvi8ff5OQ9TLp1ijq/+hZrS
        EQftWzYJnd7lB3ws=; b=s4uo7oVui7vAquSsTCPIRU4JcA2+iIUGG6IDFwUtidh
        DW7A+mm4W0NGA8YWBlYEdy6atrRHmMZqCUAQH8vkGL8FmEyRS3vbGYHd5OmQZmMN
        UEBwUojJ5D8cAny4ZGbk5kLBhVlDulJzhqUE4yRMYztL/Fb3N+/jafkdx+lWmwlw
        H8uy1zov3gnZEw3L+d3RhL6Qw5w+U9LFPiKaXP79Ted2b+oy8oBU61/+E+x/VKWR
        jiA4srdId75dVJIKKd4NuN4cy+f9zBZS0W2ub4VHDwxVEoN0QpJsuOgzBa1JQKjj
        wts9MprCvmfmOKsqtcZL15H7W/TY3iA/Vn6ivSpnqCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FItMTv
        i8ff5OQ9TLp1ijq/+hZrSEQftWzYJnd7lB3ws=; b=emm/8Hm98nL8hiPlid4knJ
        kVn8PWSSyMr3hFX9LA7WHp+THnj5ahpYXFIfeg9MTeDxEj/Dz4H2U9RghDvjdeSw
        M2xg6ZbJ/ODZ+jPXGMV47H8lzfVrAH+JZH5kqI9KShdObiPXn+ZZObRsO5eh+vDW
        L3t+ojMQxldZ2m710AgZMYa8eOgVU5xE9iwbJNUwubtgDU7svwLs8OaBa468IeYN
        T7n5QNlsSj+5HapESx3lYVIsK2QWk2UHY7e978zl0DscYBVhL5khEO4GUZWQt5iV
        viGMoAecPKalGZaUWJKHkpnyQkCoqWyj//BoIs9QsqGeQwhilRlazH0VNH+7eG/w
        ==
X-ME-Sender: <xms:M7vJYb9mJ9BYEbHawmMcMypa_WGEjlfKxaJFLaoNjsqU9tDCEHuAcg>
    <xme:M7vJYXt1IKlFjagQTJE4fV9a0Mv-puF5ONtlDZwo9qhojF8jX8GHpxI_r_2R7EDup
    D4wMdwxydYJng>
X-ME-Received: <xmr:M7vJYZDfIhvrlKQtPdCRWqA_-xTU0R1J3UcnLPmgeibtzRfhjOIEU2EOMWaKjjnRG1hW-WAHxlFCYXARm8UrvoxmOZXKReoq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddujedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:M7vJYXf8VyDn3Rf4BoOHu_LrTESHAMGuSsWYpWc-BDHtTNzj5s6aPg>
    <xmx:M7vJYQMtQf6F34E4kREA9gv0bYukPMCv8wB4LiEVPlTDHDi_WKBfkQ>
    <xmx:M7vJYZl422mYvNk95DzWqUUkMyTnMXqi78cRWCNy3LNsScEkOK0U0g>
    <xmx:M7vJYZa3lVyqzUd7peGlF_a2VwjGfxcr6aYkh4rv3RCDuCCc1FV2nw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Dec 2021 08:10:11 -0500 (EST)
Date:   Mon, 27 Dec 2021 14:10:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Marian Postevca <posteuca@mutex.one>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14] usb: gadget: u_ether: fix race in setting MAC
 address in setup phase
Message-ID: <Ycm7MYFP8SDgHp6U@kroah.com>
References: <20211225184559.15492-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211225184559.15492-1-posteuca@mutex.one>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 25, 2021 at 08:46:01PM +0200, Marian Postevca wrote:
> commit 890d5b40908bfd1a79be018d2d297cf9df60f4ee upstream.
> 
> When listening for notifications through netlink of a new interface being
> registered, sporadically, it is possible for the MAC to be read as zero.
> The zero MAC address lasts a short period of time and then switches to a
> valid random MAC address.
> 
> This causes problems for netd in Android, which assumes that the interface
> is malfunctioning and will not use it.
> 
> In the good case we get this log:
> InterfaceController::getCfg() ifName usb0
>  hwAddr 92:a8:f0:73:79:5b ipv4Addr 0.0.0.0 flags 0x1002
> 
> In the error case we get these logs:
> InterfaceController::getCfg() ifName usb0
>  hwAddr 00:00:00:00:00:00 ipv4Addr 0.0.0.0 flags 0x1002
> 
> netd : interfaceGetCfg("usb0")
> netd : interfaceSetCfg() -> ServiceSpecificException
>  (99, "[Cannot assign requested address] : ioctl() failed")
> 
> The reason for the issue is the order in which the interface is setup,
> it is first registered through register_netdev() and after the MAC
> address is set.
> 
> Fixed by first setting the MAC address of the net_device and after that
> calling register_netdev().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marian Postevca <posteuca@mutex.one>
> Fixes: bcd4a1c40bee885e ("usb: gadget: u_ether: construct with default values and add setters/getters")
> ---
>  drivers/usb/gadget/function/u_ether.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
> index 38a35f57b22c0..f59c20457e658 100644
> --- a/drivers/usb/gadget/function/u_ether.c
> +++ b/drivers/usb/gadget/function/u_ether.c
> @@ -864,19 +864,23 @@ int gether_register_netdev(struct net_device *net)
>  {
>  	struct eth_dev *dev;
>  	struct usb_gadget *g;
> -	struct sockaddr sa;
>  	int status;
>  
>  	if (!net->dev.parent)
>  		return -EINVAL;
>  	dev = netdev_priv(net);
>  	g = dev->gadget;
> +
> +	memcpy(net->dev_addr, dev->dev_mac, ETH_ALEN);
> +	net->addr_assign_type = NET_ADDR_RANDOM;
> +
>  	status = register_netdev(net);
>  	if (status < 0) {
>  		dev_dbg(&g->dev, "register_netdev failed, %d\n", status);
>  		return status;
>  	} else {
>  		INFO(dev, "HOST MAC %pM\n", dev->host_mac);
> +		INFO(dev, "MAC %pM\n", dev->dev_mac);
>  
>  		/* two kinds of host-initiated state changes:
>  		 *  - iff DATA transfer is active, carrier is "on"
> @@ -884,15 +888,6 @@ int gether_register_netdev(struct net_device *net)
>  		 */
>  		netif_carrier_off(net);
>  	}
> -	sa.sa_family = net->type;
> -	memcpy(sa.sa_data, dev->dev_mac, ETH_ALEN);
> -	rtnl_lock();
> -	status = dev_set_mac_address(net, &sa);
> -	rtnl_unlock();
> -	if (status)
> -		pr_warn("cannot set self ethernet address: %d\n", status);
> -	else
> -		INFO(dev, "MAC %pM\n", dev->dev_mac);
>  
>  	return status;
>  }
> -- 
> 2.32.0
> 

All now queued up, thanks.

greg k-h
