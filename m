Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7E261C27
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgIHTPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:15:19 -0400
Received: from host18.canaca.com ([66.49.204.205]:47170 "EHLO
        host18.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731770AbgIHTPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:15:12 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2020 15:15:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mungewell.org; s=default; h=Content-Transfer-Encoding:Content-Type:
        Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0NuhWQcldBTxDdRHEdA5HQdXlMGQ0kB4cg2kzRhE4nU=; b=jcfqXA0g4BE3azXvQ6oOuI1222
        MKa3Cexlprcf4yPE18W4BWQ0/DM5kytYj2gcp1NAW2c7KVyQZHd1s8YwT/QvoZFV2AWiRLHgteUz0
        n9M6JxR5SelYuThhbU8G3H54pK9SdogEWfYxdNrWOJotqHpwcu//xjAjMx0LUYy6sIX8tOKlXiZZ1
        GoZgq59T4eOo5GxSn5ab2xf56vGIlvdIr3EssbIwp7XOOdiwKkw9p2WEdMliUs9wsdae0BrvkkPma
        qxRWpeGcYTvle+8Io5zd3NGGD2Z/arf+OchTKZeGg7RqUZM2avubca1m1SdGXL2InMctzgvDLTKO+
        Fw1SStfA==;
Received: from [::1] (port=54410 helo=host18.canaca.com)
        by host18.canaca.com with esmtpa (Exim 4.93)
        (envelope-from <simon@mungewell.org>)
        id 1kFicC-0005pR-QJ; Tue, 08 Sep 2020 14:45:13 -0400
MIME-Version: 1.0
Date:   Tue, 08 Sep 2020 12:45:10 -0600
From:   simon@mungewell.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 69/88] ALSA: firewire-digi00x: exclude Avid
 Adrenaline from detection
In-Reply-To: <20200908152224.621006485@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
 <20200908152224.621006485@linuxfoundation.org>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <e214540d9645c4e285ee7f6475476973@mungewell.org>
X-Sender: simon@mungewell.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host18.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Get-Message-Sender-Via: host18.canaca.com: authenticated_id: simon@mungewell.org
X-Authenticated-Sender: host18.canaca.com: simon@mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-08 09:26, Greg Kroah-Hartman wrote:
> From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> 
> commit acd46a6b6de88569654567810acad2b0a0a25cea upstream.
> 
> Avid Adrenaline is reported that ALSA firewire-digi00x driver is bound 
> to.
> However, as long as he investigated, the design of this model is hardly
> similar to the one of Digi 00x family. It's better to exclude the model
> from modalias of ALSA firewire-digi00x driver.
> 
> This commit changes device entries so that the model is excluded.
> 

Just to add my 'ACK-BY'. Yes, the Avid Adrenaline seems to be based 
around a totally different method of control and will likely need a 
separate driver.

I believe that this includes the following devices: AVID Adrenaline, 
AVID Mojo, AVID Mojo SDI, AVID AV Option and others... from Windows 
driver 'FlameThrower' inf.
--
[AvidHardware.NTx86]
%Avid_Gryphon%		= Flamethrower, 1394\Avid_Technology&Gryphon
%Avid_Raven%		= Flamethrower, 1394\Avid_Technology&Raven
%Avid_Adrenaline%	= Flamethrower, 1394\Avid_Technology&Adrenaline
%Avid_FireBobPro%	= Flamethrower, 1394\Avid_Technology&FireBobPro
%Avid_Mojo%		= Flamethrower, 1394\Avid_Technology&Mojo
%Avid_FireBoB%		= Flamethrower, 1394\Avid_Technology&FireBoB
%Avid_FireBoBV2%	= Flamethrower, 1394\Avid_Technology&FireBoBV2
%Avid_DigiBoB%		= Flamethrower, 1394\Avid_Technology&DigiBoB
%Avid_AVoptionV10%	= Flamethrower, 1394\Avid_Technology&AVoptionV10
--

There are some details in this thread, for anyone interested in 
following up.
https://sourceforge.net/p/ffado/mailman/message/37078754/

Cheers,
Simon.

PS. Have a Mojo SDI inbound, will confirm when it arrives.
