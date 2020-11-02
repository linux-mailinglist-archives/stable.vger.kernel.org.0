Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49C2A2BEB
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgKBNrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:47:18 -0500
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:23037 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKBNrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:47:18 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2020 08:47:17 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1604324837;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yTF+VdjX6p5OWpe9b/y+tGUNMdySQOkPv/gTMkkGRxc=;
  b=dBfLsjA4fqynlyE3Hqh52q8uBMqEt0cm6THkURyHikuw/q0WphdULdns
   KX70UdWBnLaBmZ5/IIAgBhOMv+ygIP6Df2gAlsdE/e5fLTFB/kkrUyPGK
   dc6XgVRMXPc1PgWQCb5+KU9e1J0M8S/owsalcMmXtK2vRDHTlerDHpN6o
   0=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: gPcqAIz+53LhwLJMo8ysZnHi6nMKufypnCHjPFNTD2b3A/IZjQ6Uet5z3HIsPM77WP425nN/kf
 kaiL6FCUddcoHRJlQdcxRMEqvD+ohmEj6sR/FT3AguVWr64mB88A8BSUIh1YqpXknPte85n1Kx
 6SNoCXHxb4d2lCpRLQ+N/IsFDN9aXVqjrOcK/TI66CPzczes1nDxbVAzV3UzgGX4zcvtDVxM1A
 jOqsJ2/zzt+rzPCP4lA2WrRhN8xKWK5mqDHwTJ6gvfFi3u5hsxr632dPOyZ6JWE5MVFIERzeN/
 mPk=
X-SBRS: None
X-MesageID: 30618750
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.77,445,1596513600"; 
   d="scan'208";a="30618750"
Subject: Re: Stable backport request for "xen/events: don't use chip_data for
 legacy IRQs"
To:     Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
CC:     <stable@vger.kernel.org>
References: <0e4837c4-b750-4889-bb8c-8a36c73c7110@citrix.com>
 <1a63ad59-c0d3-893b-8098-97146920214b@suse.com>
 <20201031100314.GA3847955@kroah.com>
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
Message-ID: <fd6482d4-d28e-d1bd-9e08-daf7a36f9b79@citrix.com>
Date:   Mon, 2 Nov 2020 13:40:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201031100314.GA3847955@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-10-31 10:03, Greg KH wrote:
> [CAUTION - EXTERNAL EMAIL] DO NOT reply, click links, or open attachments unless you have verified the sender and know the content is safe.
> 
> On Fri, Oct 30, 2020 at 03:17:09PM +0100, Jürgen Groß wrote:
>> On 30.10.20 14:29, Ross Lagerwall wrote:
>>> Hi,
>>>
>>> Please backport [1] to 4.4, 4.9, 4.14, 4.19.
>>>
>>> It fixes a commit that has been backported to all the current stable releases but for some reason the fixup was only backported to 5.4 & 5.8.
>>
>> Greg has told me he queued my backport already.
> 
> I did?  I don't see that commit backported anywhere, did you get
> confused with some other patch?
> 
> I need a backported version of this patch if we are able to accept it,
> as it does not apply cleanly to those kernel releases.  Can someone
> please provide it and send it?
> 

The clean backport to older releases was sent by Jürgen on Oct 5th (subject [PATCH] xen/events: don't use chip_data for legacy IRQs).

https://lists.linaro.org/pipermail/linux-stable-mirror/2020-October/221081.html

It was queued for 5.4 but not older releases even though it applies cleanly to 4.4..4.19.

Regards,
Ross
