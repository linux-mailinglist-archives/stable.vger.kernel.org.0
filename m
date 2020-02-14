Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD915E9F1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbgBNRKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:10:20 -0500
Received: from UCOL19PA37.eemsg.mail.mil ([214.24.24.197]:61866 "EHLO
        UCOL19PA37.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392209AbgBNQNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:13:41 -0500
X-EEMSG-check-017: 76796021|UCOL19PA37_ESA_OUT04.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.70,441,1574121600"; 
   d="scan'208";a="76796021"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UCOL19PA37.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 14 Feb 2020 16:06:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1581696390; x=1613232390;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pkuyM9BpXgAmo35Ot9rhpzPQQM9SFT5CnmiggrmTKDI=;
  b=QR7fGnKdOV7G+wPK0XPFMlIJzKO8yBxIZXP6pXFCT41AfLRKTNuIK5AV
   RFAKCMd00b3CQcbAAySH51e4EuoE94tCGmeXhrWIr7iCZgq4kP7RakEby
   ktYjhrusBVEaHfZpGUQkgFrnrF1sDdpfN8/ZdyN0gWzjRTRtHUyzR71GL
   /Ql/ouN8SfE/iCOfO/tCDKrxZ/NljqD1ah2NtslwUgDb5IExcd1f80h6/
   VtCnd7QPYa/aAFFVMvdnqIwtz1i+1Meu1sXOyz2udPgHml+FZ87McHhOb
   W45f+RC7F+LUydVmnp5E2En3KD1565hJsXJg6taCotZKtqAzNdcgLQTsZ
   A==;
X-IronPort-AV: E=Sophos;i="5.70,441,1574121600"; 
   d="scan'208";a="39137111"
IronPort-PHdr: =?us-ascii?q?9a23=3A4pCgqBCRARvRfDj+JdDCUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP36oMSwAkXT6L1XgUPTWs2DsrQY0raQ7PirCTdIyK3CmU5BWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRq7oR/Tu8UKjodvKag8wQ?=
 =?us-ascii?q?bVr3VVfOhb2WxnKVWPkhjm+8y+5oRj8yNeu/Ig885PT6D3dLkmQLJbETorLX?=
 =?us-ascii?q?k76NXkuhffQwSP4GAcUngNnRpTHwfF9hD6UYzvvSb8q+FwxTOVPczyTbAzRD?=
 =?us-ascii?q?Si86JmQwLmhSsbKzI09nzch9duh6xHvh2uux1/w5bVYI6LMvp+Yrjdds4eSW?=
 =?us-ascii?q?ZYQ8pdSzBNDoa6YoQBFeoBOftToZf7qVUAsBCyARCgCP3rxzNNgHL9wK803P?=
 =?us-ascii?q?k7EQzewQIuAdwOvnTXotv7OqgdXuK6w7XHwzjYc/Nb2y3w5JTUfh0vo/yBW6?=
 =?us-ascii?q?97f8rLyUkoEgPIlkieqZD7MDON1uQCrW6b5Pd9W+KqkWEnrwVxrSavx8wxjY?=
 =?us-ascii?q?TJnZ8aykvf+CVlwIc6Od24SElhbd6iC5tfrTuWN4RxQsM8WmxlvjsxxL4euZ?=
 =?us-ascii?q?OjYSQHx5sqywTfZvCaaYSE/B3uWPiLLTtlgn9uZaixiAyo8Ue6z+3xTsy00F?=
 =?us-ascii?q?FXoSVbitTMrXUN1wDL6siAV/t94l+t2TaR2ADX7eFJOVw0mrDBK54g374wjY?=
 =?us-ascii?q?AfsUXFHi/4n0X2l7GZeVk+9ui06+XofrXmppiGO49ylg7+Kbghlta6AeQ5Ng?=
 =?us-ascii?q?gCR2mb+eKi273/5UD1XbpHg/IsnqTZrZzWP9oXq6GnDwNPz4ov8xO/AC2n0N?=
 =?us-ascii?q?Qck3kHNlVFeBefgojyJl7OO+v1Deu/gluwkDdrwOrKPrv6AprXNHTDn7Dhfa?=
 =?us-ascii?q?hl505G1AUz1cxf545TCrwZO/L8QFTxtNzCAR89KAG0wPjoCM971owAXWKDGK?=
 =?us-ascii?q?iZMLndsVWQ/OIgP/GMZJMJuDb6M/Ul4//ujXkkmV4SZKWp3oUYaGq+Hvt4J0?=
 =?us-ascii?q?WUemTsgtgfHmcQpAY+T/LliEeEUTFNY3a+RaU85is0CIi+F4fMWpitgKCd3C?=
 =?us-ascii?q?e8BpBWfXxGBUqXHnfsaYqJQOkMaC2MLc97iDAEVqauS5Un1R6wsA/20b1nLv?=
 =?us-ascii?q?Db+icAr5LsyMB15/HPlRE17TF0F96S03yJT2xvhmMHXSI23KRmrUx4zVeD1r?=
 =?us-ascii?q?J4jOJCGdNP4PNJVx8wNYTAwOxiF9DyRgXBc8+TSFa9Q9WpHCw+TtUzw98PeE?=
 =?us-ascii?q?tyB9KigQ3d0CWwHr8VjbuLBIYu/a7G2HjxPcl9wW7c1KY9l1kmXtdPNWq+i6?=
 =?us-ascii?q?5k6QfTA4/Jk0OEl6elbqkcwiHN+3mZzWaUv0FXThRwUaPbUnAbfEfWqs755k?=
 =?us-ascii?q?yRB4OpXI8uKQtIgeqPNKpMIonyhE5GTfPLO9nEZW+13WCqCkDMjreNapf6Pm?=
 =?us-ascii?q?YQxiPQDGAanA0Ju3WLLw4zAmGmuW2aRCdyHFjrbmvy/uRk7nC2VEk5y0eNdU?=
 =?us-ascii?q?Iy+aCy/0sumfGES/4VlokBsSMlpiQ8SE2xxPrKGtGAoExnZ6wabtQjtgQUnV?=
 =?us-ascii?q?nFvhBwa8TzZ5tpgUQTJkEu5RLj?=
X-IPAS-Result: =?us-ascii?q?A2BMAAAPxUZe/wHyM5BmGgEBAQEBAQEBAQMBAQEBEQEBA?=
 =?us-ascii?q?QICAQEBAYF7gX2BbSASKoQUiQOGWQEBBAaBN4lwkUoJAQEBAQEBAQEBNwQBA?=
 =?us-ascii?q?YRAAoIlOBMCEAEBAQUBAQEBAQUDAQFshUOCOykBgwEBAQEBAyMEEUEQCxUDA?=
 =?us-ascii?q?gIfBwICVwYBDAYCAQGCYz+CVyWtInV/M4VKg0aBPoEOKow+eYEHgREnD4JdP?=
 =?us-ascii?q?odbgl4EjWSJY0aXbYJEgk+TfAYcmxgtjjudPyKBWCsIAhgIIQ87gmxQGA2OK?=
 =?us-ascii?q?RcVjiwjAzCQWAEB?=
Received: from tarius.tycho.ncsc.mil (HELO tarius.infosec.tycho.ncsc.mil) ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 14 Feb 2020 16:06:29 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.infosec.tycho.ncsc.mil (8.14.7/8.14.4) with ESMTP id 01EG5UMo166729;
        Fri, 14 Feb 2020 11:05:30 -0500
Subject: Re: [PATCH AUTOSEL 5.5 190/542] selinux: ensure we cleanup the
 internal AVC counters on error in avc_insert()
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, rsiddoji@codeaurora.org,
        selinux@vger.kernel.org
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-190-sashal@kernel.org>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <64b56666-4e4a-10e0-0a1d-60ee28615d23@tycho.nsa.gov>
Date:   Fri, 14 Feb 2020 11:07:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214154854.6746-190-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/20 10:43 AM, Sasha Levin wrote:
> From: Paul Moore <paul@paul-moore.com>
> 
> [ Upstream commit d8db60cb23e49a92cf8cada3297395c7fa50fdf8 ]
> 
> Fix avc_insert() to call avc_node_kill() if we've already allocated
> an AVC node and the code fails to insert the node in the cache.
> 
> Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
> Reported-by: rsiddoji@codeaurora.org
> Suggested-by: Stephen Smalley <sds@tycho.nsa.gov>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You should also apply 030b995ad9ece9fa2d218af4429c1c78c2342096 
("selinux: ensure we cleanup the internal AVC counters on error in 
avc_update()") which fixes one additional instance of the same kind of 
bug not addressed by this patch.

> ---
>   security/selinux/avc.c | 51 ++++++++++++++++++++----------------------
>   1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index 23dc888ae3056..6646300f7ccb2 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -617,40 +617,37 @@ static struct avc_node *avc_insert(struct selinux_avc *avc,
>   	struct avc_node *pos, *node = NULL;
>   	int hvalue;
>   	unsigned long flag;
> +	spinlock_t *lock;
> +	struct hlist_head *head;
>   
>   	if (avc_latest_notif_update(avc, avd->seqno, 1))
> -		goto out;
> +		return NULL;
>   
>   	node = avc_alloc_node(avc);
> -	if (node) {
> -		struct hlist_head *head;
> -		spinlock_t *lock;
> -		int rc = 0;
> -
> -		hvalue = avc_hash(ssid, tsid, tclass);
> -		avc_node_populate(node, ssid, tsid, tclass, avd);
> -		rc = avc_xperms_populate(node, xp_node);
> -		if (rc) {
> -			kmem_cache_free(avc_node_cachep, node);
> -			return NULL;
> -		}
> -		head = &avc->avc_cache.slots[hvalue];
> -		lock = &avc->avc_cache.slots_lock[hvalue];
> +	if (!node)
> +		return NULL;
>   
> -		spin_lock_irqsave(lock, flag);
> -		hlist_for_each_entry(pos, head, list) {
> -			if (pos->ae.ssid == ssid &&
> -			    pos->ae.tsid == tsid &&
> -			    pos->ae.tclass == tclass) {
> -				avc_node_replace(avc, node, pos);
> -				goto found;
> -			}
> +	avc_node_populate(node, ssid, tsid, tclass, avd);
> +	if (avc_xperms_populate(node, xp_node)) {
> +		avc_node_kill(avc, node);
> +		return NULL;
> +	}
> +
> +	hvalue = avc_hash(ssid, tsid, tclass);
> +	head = &avc->avc_cache.slots[hvalue];
> +	lock = &avc->avc_cache.slots_lock[hvalue];
> +	spin_lock_irqsave(lock, flag);
> +	hlist_for_each_entry(pos, head, list) {
> +		if (pos->ae.ssid == ssid &&
> +			pos->ae.tsid == tsid &&
> +			pos->ae.tclass == tclass) {
> +			avc_node_replace(avc, node, pos);
> +			goto found;
>   		}
> -		hlist_add_head_rcu(&node->list, head);
> -found:
> -		spin_unlock_irqrestore(lock, flag);
>   	}
> -out:
> +	hlist_add_head_rcu(&node->list, head);
> +found:
> +	spin_unlock_irqrestore(lock, flag);
>   	return node;
>   }
>   
> 

