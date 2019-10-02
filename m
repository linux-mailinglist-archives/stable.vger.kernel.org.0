Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4EC938D
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 23:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfJBVgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 17:36:36 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:48736 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729042AbfJBVgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 17:36:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 18FDF18024AE5;
        Wed,  2 Oct 2019 21:36:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3871:3872:4321:4425:5007:7514:7576:10004:10400:11026:11232:11473:11657:11658:11914:12043:12297:12438:12555:12740:12760:12895:13069:13255:13311:13357:13439:14096:14097:14181:14659:14721:14877:21080:21451:21611:21627:21939:30012:30054:30091,0,RBL:47.151.152.152:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:29,LUA_SUMMARY:none
X-HE-Tag: cake40_1c3454dfe8209
X-Filterd-Recvd-Size: 2626
Received: from XPS-9350.home (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed,  2 Oct 2019 21:36:33 +0000 (UTC)
Message-ID: <6436567dd141e5528a5363dd3aaad21815a1c111.camel@perches.com>
Subject: Re: [PATCH 3.16 29/87] staging: iio: cdc: Don't put an else right
 after a return
From:   Joe Perches <joe@perches.com>
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 02 Oct 2019 14:36:32 -0700
In-Reply-To: <lsq.1570043211.136218297@decadent.org.uk>
References: <lsq.1570043211.136218297@decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-10-02 at 20:06 +0100, Ben Hutchings wrote:
> 3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

This doesn't look necessary.

> ------------------
> 
> From: Catalina Mocanu <catalina.mocanu@gmail.com>
> 
> commit 288903f6b91e759b0a813219acd376426cbb8f14 upstream.
> 
> This fixes the following checkpatch.pl warning:
> WARNING: else is not generally useful after a break or return.
> 
> While at it, remove new line for symmetry with the rest of the code.
> 
> Signed-off-by: Catalina Mocanu <catalina.mocanu@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/staging/iio/cdc/ad7150.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> --- a/drivers/staging/iio/cdc/ad7150.c
> +++ b/drivers/staging/iio/cdc/ad7150.c
> @@ -143,19 +143,15 @@ static int ad7150_read_event_config(stru
>  	case IIO_EV_TYPE_MAG_ADAPTIVE:
>  		if (dir == IIO_EV_DIR_RISING)
>  			return adaptive && (threshtype == 0x1);
> -		else
> -			return adaptive && (threshtype == 0x0);
> +		return adaptive && (threshtype == 0x0);
>  	case IIO_EV_TYPE_THRESH_ADAPTIVE:
>  		if (dir == IIO_EV_DIR_RISING)
>  			return adaptive && (threshtype == 0x3);
> -		else
> -			return adaptive && (threshtype == 0x2);
> -
> +		return adaptive && (threshtype == 0x2);
>  	case IIO_EV_TYPE_THRESH:
>  		if (dir == IIO_EV_DIR_RISING)
>  			return !adaptive && (threshtype == 0x1);
> -		else
> -			return !adaptive && (threshtype == 0x0);
> +		return !adaptive && (threshtype == 0x0);
>  	default:
>  		break;
>  	}
> 

