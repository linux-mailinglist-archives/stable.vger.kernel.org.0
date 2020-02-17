Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DDB161BDD
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgBQTum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:50:42 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:40843 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgBQTum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:50:42 -0500
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 1CCC1497; Mon, 17 Feb 2020 20:50:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1581969040;
        bh=BsLBTZKMBdNFs3dQyeV7yjU56mYhCqCfMc+Nbxvd5/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLpBpVcf3bxmCGRqCJfiyAVs1Bwm1Xag0VHnku78ez4P5qmLl8is7J8IxoI7tmKwv
         OB8U6sCUWFnAH7onL7RHo1CdGprMgDxErPcQSmSpCkp3TrsTrgpk+bk+M1+9Nh1WUC
         rVVpsrUUQAa1smeSM+9T0ahOkZe/EAcWJS/pMnbTuiuD/EZJIyrCzCfTz8DjfJBLwi
         OsmJKaqbeKX563AXttxyACgn90TlBJS2kPUFXEBYRm/utX+0tyTf7jdKBXBBbpaO5K
         3yA/mtlPgn8S/WkZGhQQ/2G3TLpP89hZuK84sPTGCrz54IFCClAIHJp6wicesAP0+7
         U233TBS2gxkhw==
Date:   Mon, 17 Feb 2020 20:50:40 +0100
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Gang He <GHe@suse.com>
Subject: Re: ocfs2 fix for 5.4 LTS
Message-ID: <20200217195040.GF18366@valentin-vidic.from.hr>
References: <20200217192155.GE18366@valentin-vidic.from.hr>
 <20200217193207.GA1724751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217193207.GA1724751@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:32:07PM +0100, Greg KH wrote:
> It's already in the 5.4.9 kernel release, does that not work properly
> for you?

Ah sorry, should have checked all the changelogs for 5.4.
All good then :)

-- 
Valentin
