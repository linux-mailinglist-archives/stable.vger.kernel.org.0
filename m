Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CAB296087
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 15:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900536AbgJVN7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 09:59:20 -0400
Received: from aibo.runbox.com ([91.220.196.211]:51822 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900534AbgJVN7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 09:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=e4L2Skc/u+U3cTDg4U5BffAKA96T/CEy6T+u2+GyPvk=; b=M0ZtZtZLjDUjRk0LLanee/HAmv
        xDpADo108zljwYNhaohNC+Z4DzKxc7B+icxWmYZ8KZKFYrVkLwk7CN9wN27ZMT16WXQEynyDF63V3
        8HfAJP6DY7EcgFmZ12HxcdS5H0sV9tP/7/dU7cKN741xMi98UvZXuEgob3Aq5avb6EBJ9hRO+ijAZ
        jUlCoEhl4czJxQ0dFp6a2KasuDHSEGUmICt8CSbDHxke/LeDv2hfhXuNuUjY2TdaoRxk7XQ8k6hBH
        r1dnDVwpHFgJEdG7N8/ZcIqSpkUvfjlDUBn6X5DTSi3Lnob26PpwIJ8mnhCoRF2Z+hlmTCxLqn6YW
        FF9QgcZw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kVb7c-0001h0-NI; Thu, 22 Oct 2020 15:59:16 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kVb7b-0007Bp-BX; Thu, 22 Oct 2020 15:59:15 +0200
Subject: Re: [PATCH 1/2] usbcore: Check both id_table and match() when both
 available
To:     linux-usb@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com>
 <20201022135521.375211-2-m.v.b@runbox.com>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <dc03de23-f1f7-7948-ce18-a1d53567e50a@runbox.com>
Date:   Thu, 22 Oct 2020 09:59:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201022135521.375211-2-m.v.b@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/10/2020 09.55, M. Vefa Bicakci wrote:
> From: Bastien Nocera <hadess@hadess.net>
> 
> From: Bastien Nocera <hadess@hadess.net>

Ah, sorry for this mistake. This is the first time I sent patches
authored by another person, with git-send-email. I should have
tested with my own e-mail address initially.

I will fix this mistake with the next patch set version.

Thank you,

Vefa

