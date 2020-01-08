Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF1F133858
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 02:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgAHBRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 20:17:13 -0500
Received: from avon.wwwdotorg.org ([104.237.132.123]:36496 "EHLO
        avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgAHBRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 20:17:13 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2020 20:17:12 EST
Received: from [10.20.204.51] (unknown [216.228.112.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by avon.wwwdotorg.org (Postfix) with ESMTPSA id 1AF191C0917;
        Tue,  7 Jan 2020 18:09:29 -0700 (MST)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.101.4 at avon.wwwdotorg.org
To:     James Morse <james.morse@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ARM kernel mailing list 
        <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
From:   Stephen Warren <swarren@wwwdotorg.org>
Subject: "arm64: alternatives: use tpidr_el2 on VHE hosts" v4.9 backport
 missing edits to proc.S
Message-ID: <a1cb6ca5-4806-0813-3aad-1246e65162a6@wwwdotorg.org>
Date:   Tue, 7 Jan 2020 18:09:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

James,

I'm looking at commit 6d99b68933fbcf51f84fcbba49246ce1209ec193 ("arm64: 
alternatives: use tpidr_el2 on VHE hosts"). When it was back-ported to 
v4.9.x as eea59020a7f2993018ccde317387031c04c62036, the changes to 
arch/arm64/mm/proc.S weren't included. I assume this was just an 
accident, or was there some specific reason for this? Either way, I do 
find that I need those changes for system suspend/resume to work in my 
downstream vendor fork of v4.9 if I enable KVM support in .config. I'm 
happy to send a patch for v4.9.x to add those changes back if that's the 
way to go. v4.14.x and later don't have this issue.

Thanks.
