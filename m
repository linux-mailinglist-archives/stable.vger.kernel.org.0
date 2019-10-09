Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA82D0B8F
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfJIJnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:43:14 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37027 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbfJIJnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:43:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2202A4D6;
        Wed,  9 Oct 2019 05:43:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 05:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=w/1gU/6feiD6Ow0s4cE+tnjiLAI
        dE9nHmPgN4uVKBEg=; b=Yva0+YeBpXFlwqNWgCEt0edcYIvsO40QHa4yXxlHdfx
        7fT6GTx9Hc0OyNuhLqI6+aF8ivC3hOsRtxgw9oovLUoTIrq6L289rx5l4eljmslz
        8HC1T8lxLR4hXAwHSv7rIDW9DhMfoBsC3PDWBl1BkPWsmjdn3dWSgNdl8xrG6BUt
        hx4mZVF0BPbhmuYdjMSdcKBIERiv9dcoLdgC3INsulGKwECJsP7GjnLS7GmIJYNO
        dcVV9iVg25wsJpNCra3yTLB9qn2/cEH4evP6fDPfLN6RAUf57sf3lmQwGUVO+Rj+
        LcwK7/O0E/ihNhqNyvb1xh6EQXNo/6I6iA9k9o3I11Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=w/1gU/
        6feiD6Ow0s4cE+tnjiLAIdE9nHmPgN4uVKBEg=; b=PqVvVHXlE0dPeV2tEzgNjb
        FA3rqNgs9BaIG/RzihQgjZ/f0IVieUp8a605dUEu8x8iKDhAGBjLb7TEc5rCzH8f
        h5QtJenn7HrWsdxNtKaFY3xW+B0T7UjaHzhzWWMpkoNV7lxTtdyq5m2LwwEfNnEZ
        JJWteSh0bB/0h9AbnwWm9Pcp7ykabQ+OFLEzujj6ui98CPbbPY7dmPH20p8ky8UC
        E/mfTvWJcK8NFyRtty9xUGfvd9/laRf75TtFSpX0TXm2d2FCoelTP7JueE97jNBt
        wAEKD+m+bPZpAmXVlPMoF6kn3J9APVGwRfHQljtZrgp2R44ra5c4piMW/hwdlEAA
        ==
X-ME-Sender: <xms:sKudXRxVGlEbUo4wrm7F_0LKijnUbUz733z7WRd2jWnkc29jxFAPvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:sKudXQNqqIKlM_5EuMqJwaIHVoglBHDPdfQVpq648CC6vjxQLi4UjA>
    <xmx:sKudXXZIYnntKBa9CaALLgQ9vcVHERv_INp78srsVux73hgrGg-MCA>
    <xmx:sKudXXBOnn1nOUiAArUhYtj8ypbMRJbDiLGUE6O9Q0PqNc5rL40JRg>
    <xmx:sKudXT16GjWgzQBS7Hh1Qcy2ooU5t8g9CF55wQY2X3HPlQfFUM6tKw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD94C8005C;
        Wed,  9 Oct 2019 05:43:11 -0400 (EDT)
Date:   Wed, 9 Oct 2019 11:43:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.4, 4.9, 4.14, 4.19] nl80211: validate beacon head
Message-ID: <20191009094310.GA3945119@kroah.com>
References: <1570603265-@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570603265-@changeid>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 08:41:09AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Commit 8a3347aa110c76a7f87771999aed491d1d8779a8 upstream.
> 
> We currently don't validate the beacon head, i.e. the header,
> fixed part and elements that are to go in front of the TIM
> element. This means that the variable elements there can be
> malformed, e.g. have a length exceeding the buffer size, but
> most downstream code from this assumes that this has already
> been checked.
> 
> Add the necessary checks to the netlink policy.
> 
> Cc: stable@vger.kernel.org
> Fixes: ed1b6cc7f80f ("cfg80211/nl80211: add beacon settings")
> Link: https://lore.kernel.org/r/1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 6168db3c35e4..4a10ab388e0b 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -200,6 +200,38 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
>  	return __cfg80211_rdev_from_attrs(netns, info->attrs);
>  }
>  
> +static int validate_beacon_head(const struct nlattr *attr,
> +				struct netlink_ext_ack *extack)
> +{
> +	const u8 *data = nla_data(attr);
> +	unsigned int len = nla_len(attr);
> +	const struct element *elem;
> +	const struct ieee80211_mgmt *mgmt = (void *)data;
> +	unsigned int fixedlen = offsetof(struct ieee80211_mgmt,
> +					 u.beacon.variable);
> +
> +	if (len < fixedlen)
> +		goto err;
> +
> +	if (ieee80211_hdrlen(mgmt->frame_control) !=
> +	    offsetof(struct ieee80211_mgmt, u.beacon))
> +		goto err;
> +
> +	data += fixedlen;
> +	len -= fixedlen;
> +
> +	for_each_element(elem, data, len) {
> +		/* nothing */
> +	}

for_each_element() is not in 4.4, 4.9, 4.14, or 4.19, so this breaks the
build :(

I'll drop this from my queues for now.

thanks,

greg k-h
