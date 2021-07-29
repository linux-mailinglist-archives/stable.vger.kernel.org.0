Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397883DAA8B
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG2R6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 13:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2R6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 13:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C8A60F43;
        Thu, 29 Jul 2021 17:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627581478;
        bh=sHVAtdltvNlYJDlFbFo8fnDl6wpPZ8/yhEYynksMt+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYJ/oO9nNVRcdy/tM8Bmwbi4SZ1GCK4UBbF09czq4r4IP/fmhVtHVZdWehF+FGnu7
         59ymxbsroLfzIFHjqCk/PD29xtP5SMkSUQV978aWer3yIBmPj3V8IA+KNyfqfFUYCl
         gzQXlhSwDRT3yBIzDqDhFjz5NpIcBxDsKqEgznoKpJpGSk65fL+0+OX66dtUI0cfWw
         zhAFHENMUOBUiElkCJRXaMH2Rr6LcsnO25gAY49f9DZfzfEvCX7w2mzZo+APVbnP9C
         W/XXvs8W6rH2IF7EoqMlarfu97W8Pvf2ujYW8pwmzCSc4YGS8OrLuo5DjDxL/SL0wV
         mVG7b3M7d35fA==
Date:   Thu, 29 Jul 2021 13:57:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     PGNet Dev <pgnet.dev@gmail.com>
Cc:     rafael@kernel.org, gregkh@linuxfoundation.org,
        hui.wang@canonical.com, linux-acpi@vger.kernel.org,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org,
        manuelkrause@netscape.net
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ
 override"
Message-ID: <YQLsJUqc3kgQGvMP@sashalap>
References: <20210728151958.15205-1-hui.wang@canonical.com>
 <YQGA4Kj2Imz44D3k@kroah.com>
 <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
 <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 12:52:20PM -0400, PGNet Dev wrote:
>On 7/28/21 12:38 PM, Rafael J. Wysocki wrote:
>>On Wed, Jul 28, 2021 at 6:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>Applied as 5.14-rc material, thanks!
>
>ty!
>
>Will this revert be auto-magically backported to earlier stable (5.12x/5.13x) trees?
>Or does that require a manual trigger?
>Or, is that a distro kernel release issue?

Since it has a cc to stable it should happen automagically.

-- 
Thanks,
Sasha
