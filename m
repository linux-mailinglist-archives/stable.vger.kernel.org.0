Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1807B296FB8
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464089AbgJWMvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 08:51:49 -0400
Received: from aibo.runbox.com ([91.220.196.211]:48448 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S464051AbgJWMvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 08:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=5kunZymvhYgefY2lrHj6qtRGIFmGO0ZQe8ZqTJGqpJE=; b=TfKvtvdSV2ponF1iJyaUvqTssT
        DK4SDgbcGFgfliYMd23fPA4PX7Qu0fbtIag+eosPnR+Sve0jXelXyAIWs91GT79zzOVJnyJJU2A96
        vTbjc1h2BPyRuqmfvo4sBHjC+1Iqx+EXnSOUV4xCs13cp5pSP2PbkKq+zguLAfvqdPQ9K662z/+Rq
        YAkuq6XTOtnojrDJSFlvJpoofsbZ88cfh1eHLIwuUg005AeprxkGgi/UKhb7NTftCZpyHfp7r+wKa
        eiHp+SmLvp1iHrvqqfSeIqzSkFkSKLyJ0fh4G1F2AYyuPEwrFRv6Fo7DJcd46TNrighjZsrz+Od3R
        66/afnpA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kVwXq-00041m-1Y; Fri, 23 Oct 2020 14:51:46 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kVwXh-0007XM-Hq; Fri, 23 Oct 2020 14:51:37 +0200
Subject: Re: [PATCH 1/2] usbcore: Check both id_table and match() when both
 available
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Bastien Nocera <hadess@hadess.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com>
 <20201022135521.375211-2-m.v.b@runbox.com>
 <dc03de23-f1f7-7948-ce18-a1d53567e50a@runbox.com>
 <CAHp75VeBgQ2ywLzU5PZEdfS+9M_niD0KoiEG=UMNH+4cPfsCNw@mail.gmail.com>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <ef3cce3a-5dc2-8013-a47d-c08d1eaa7f02@runbox.com>
Date:   Fri, 23 Oct 2020 08:51:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VeBgQ2ywLzU5PZEdfS+9M_niD0KoiEG=UMNH+4cPfsCNw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/10/2020 03.08, Andy Shevchenko wrote:
> 
> 
> On Thursday, October 22, 2020, M. Vefa Bicakci <m.v.b@runbox.com <mailto:m.v.b@runbox.com>> wrote:
> 
>     On 22/10/2020 09.55, M. Vefa Bicakci wrote:
> 
>         From: Bastien Nocera <hadess@hadess.net <mailto:hadess@hadess.net>>
> 
>         From: Bastien Nocera <hadess@hadess.net <mailto:hadess@hadess.net>>
> 
> 
>     Ah, sorry for this mistake. This is the first time I sent patches
>     authored by another person, with git-send-email. I should have
>     tested with my own e-mail address initially.
> 
>     I will fix this mistake with the next patch set version.
> 
> 
> 
> Also you may use BugLink tag instead of Link.

Thank you, Andy! I will revise the patch description with
the next patch set to use the BugLink tag.
