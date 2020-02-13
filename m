Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F282615C72F
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388398AbgBMQHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:07:53 -0500
Received: from USFB19PA36.eemsg.mail.mil ([214.24.26.199]:51361 "EHLO
        USFB19PA36.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbgBMQHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 11:07:52 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 11:07:52 EST
X-EEMSG-check-017: 55804223|USFB19PA36_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.70,437,1574121600"; 
   d="scan'208";a="55804223"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by USFB19PA36.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 13 Feb 2020 16:00:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1581609637; x=1613145637;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KIcuSejQnqpI1jbM63RzeE7p+CVUNEGm6AHO7WK6rr4=;
  b=lu6hMfThc7yL6BWv6oMlFR9fNRZdBCDTOsfa5EkqbasRNX9bgtpP5M97
   KDzGo0lK9IjYhaTGpVaPEN+R4hUodJDKB07KgMRylhEiQQvK2KzROKlPN
   RIsypEhsFdLePA96QgkAB2CYM7hHJ4p3oQEkmShJ8lOhG6NO6jqwNfJSp
   HFNzB4kmKyZ4nNeKAeXtkE+pdu87BzWqEq4CRIraJi8QIJ4SKHmwqGd2s
   No/BwGWAliQy+5GYvEZLM/qpUsrhqKiHT82aVWfOvYjzK1rRMPIRfF96+
   pf6JoAXhc+TV9eUbtJ0gKRGqs5poOnw+w7RExtl5U+tCEANB1rIcOGdrQ
   w==;
X-IronPort-AV: E=Sophos;i="5.70,437,1574121600"; 
   d="scan'208";a="33030530"
IronPort-PHdr: =?us-ascii?q?9a23=3AaSjTkB2aIbMKZLWismDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesXK/zxwZ3uMQTl6Ol3ixeRBMOHsq4C1bqd4/mocFdDyKjCmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfLx/IA+3oAjSucUbgpZuIbstxx?=
 =?us-ascii?q?XUpXdFZ+tZyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/XrJgcJskq1UvBOhpwR+w4HKZoGVKOF+db7Zcd8DWG?=
 =?us-ascii?q?ZNQtpdWylHD4yydYsPC/cKM/heoYfzulACqQKyCReoCe/qzDJDm3340rAg0+?=
 =?us-ascii?q?k5DA/IwgIgEdINvnraotr6O6UdXvy6wqTT0TXObelb1Svh5IXGcB0sp+yHU7?=
 =?us-ascii?q?JqccrWzEkiDx7LjkmOpoz9PzOayOINuHWG4eplT+2vj2onpB9xozOywcoskZ?=
 =?us-ascii?q?TGhpkOx1DY9SR23IY1JdqiRE59et6rCoFcty6dN4toW84vRXxjtiUiyrAepJ?=
 =?us-ascii?q?K2cycHxI4nyhLCcfCLbYeF7gz5WOqMJzpzmWhrd6ilhxmo9Eit0uj8Vs6p31?=
 =?us-ascii?q?lUtidFidzMtmwV1xzU98iHVuNx/ke/1jaL0ADe8v1ELloularaNp4h2aQ8lp?=
 =?us-ascii?q?sVsUTNGS/2g1v5g7OMekU4+umn9+TnYrL8qp+aK4B0kR3xPr4rmsy+BeQ0Kg?=
 =?us-ascii?q?kOX26F9uSgzLDv4EL0TbpQgvA2j6XVqo7WKMsFqqKjHgNZyoMj5Ay+Dzei3t?=
 =?us-ascii?q?QYh34HLFdddRKckofpIErDIOz4DPijg1Ssly1nx/bdPrL7GJnNIX/DkKn5cb?=
 =?us-ascii?q?Zn90Fc0BYzzcxY559MBbEBOuz8WkDytNzYFRI5Nw20w+D6CNRy2IMeXn+PAq?=
 =?us-ascii?q?mEP6zIrV+I5+UvI++WaI8Sojb9JOAv5+Tygn8hhV8dYa6p0IMTaHC5GPRmPk?=
 =?us-ascii?q?qYbWPvgtgfC2cKuBQxTOjxhV2cXj5ceWyyU7g/5j4lEoKmC5nMRoS3jLyGxi?=
 =?us-ascii?q?e7EYVcZnpaBVCUDXfoa4KEVu8XaCKOOMBuiTgEWqa6Ro8/2hGhqhX6x6BkLu?=
 =?us-ascii?q?XK4C0Ys4zs1Nxv6+3UjxEy+iR+D96B3GGVU2F0gmQISic43aB+pUx9zkyO0a?=
 =?us-ascii?q?tmjPxCE9xc+fdJXh09NZ7GwOxwE8ryVR7ZfteVVFamRc2rASkrQdIsx98DeF?=
 =?us-ascii?q?59FM+/jhDHxiaqBrgVl7uRBJMq6K7Tw3/xJ8Mug0rBgYY7glZuYdFIPG3jpq?=
 =?us-ascii?q?dl6w3aAcadnF+UmKWqXaAd2jPd+mCey2aHoEBfVkh3S6qTGTgbZ03LvZH661?=
 =?us-ascii?q?nEQruGF7sqKE1CxNSEJ68Mbcfm3ntcQ/K2A8jTe2K8nS+LAB+Mwr6dJN7xd3?=
 =?us-ascii?q?41wDTWCE9ClRsau3mBK15tVW+av2vCAWk2RhrUaET2/Lw78SnqQw=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2DmAABlcUVe/wHyM5BmGwEBAQEBAQEFAQEBEQEBAwMBA?=
 =?us-ascii?q?QGBe4F9gW0gEiqEFIkDhl8GgTeJcJFKCQEBAQEBAQEBATcEAQGEQAKCcDgTA?=
 =?us-ascii?q?hABAQEFAQEBAQEFAwEBbIVDgjspAYMBAQEBAQMjFUEQCxUDAgImAgJXBgEMB?=
 =?us-ascii?q?gIBAYJjP4JXJawZdYEyhUqDToE+gQ4qjD55gQeBOA+CXT6HW4JeBJdFRpdrg?=
 =?us-ascii?q?kSCT5N8BhybFy2OO50+IoFYKwgCGAghD4MnUBgNjlWOLCMDMI8hAQE?=
Received: from tarius.tycho.ncsc.mil (HELO tarius.infosec.tycho.ncsc.mil) ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 13 Feb 2020 16:00:35 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.infosec.tycho.ncsc.mil (8.14.7/8.14.4) with ESMTP id 01DFxZqs258318;
        Thu, 13 Feb 2020 10:59:37 -0500
Subject: Re: [PATCH 5.4 85/96] selinux: revert "stop passing MAY_NOT_BLOCK to
 the AVC upon follow_link"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Paul Moore <paul@paul-moore.com>
References: <20200213151839.156309910@linuxfoundation.org>
 <20200213151911.147099125@linuxfoundation.org>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <b481f512-d4dd-1c04-f39f-0ba271193d0a@tycho.nsa.gov>
Date:   Thu, 13 Feb 2020 11:01:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151911.147099125@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/20 10:21 AM, Greg Kroah-Hartman wrote:
> From: Stephen Smalley <sds@tycho.nsa.gov>
> 
> commit 1a37079c236d55fb31ebbf4b59945dab8ec8764c upstream.
> 
> This reverts commit e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK
> to the AVC upon follow_link"). The correct fix is to instead fall
> back to ref-walk if audit is required irrespective of the specific
> audit data type.  This is done in the next commit.
> 
> Fixes: e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK to the AVC upon follow_link")
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This patch should be accompanied by commit 
0188d5c025ca8fe756ba3193bd7d150139af5a88 ("selinux: fall back to 
ref-walk if audit is required").  The former is reverting an incorrect 
fix for bda0be7ad994 ("security: make inode_follow_link RCU-walk 
aware"), the latter is providing the correct fix for it.

> 
> ---
>   security/selinux/avc.c         |   24 ++++++++++++++++++++++--
>   security/selinux/hooks.c       |    5 +++--
>   security/selinux/include/avc.h |    5 +++++
>   3 files changed, 30 insertions(+), 4 deletions(-)

[...]
