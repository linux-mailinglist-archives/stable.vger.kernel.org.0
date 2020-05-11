Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048691CE192
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgEKRV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:21:56 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:60408 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730970AbgEKRVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 13:21:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jYC7h-0001Fq-To; Mon, 11 May 2020 18:21:50 +0100
Message-ID: <6a43d9b82e321aef0324d10a5e2f3dc4961a7fe9.camel@codethink.co.uk>
Subject: Re: [PATCH 5.4 00/50] 5.4.40-rc1 review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     shuah <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Mon, 11 May 2020 18:21:48 +0100
In-Reply-To: <e090d5ed-3e18-333e-221b-197a30c102e8@kernel.org>
References: <20200508123043.085296641@linuxfoundation.org>
         <e090d5ed-3e18-333e-221b-197a30c102e8@kernel.org>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-05-11 at 10:35 -0600, shuah wrote:
> On 5/8/20 6:35 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.40 release.
> > There are 50 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.40-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. I am seeing the following
> regression in dmesg and with a new emergency message.
> 
> Initramfs unpacking failed: Decoding failed
> 
> I don't know why yet. I will debug and let you know.

At a guess: you upgraded to Ubuntu 20.04, and the default initramfs
compression changed to lz4.  Or something like that.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

