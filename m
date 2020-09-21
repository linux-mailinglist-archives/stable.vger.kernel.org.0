Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD003272B90
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgIUQSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:18:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:64007 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIUQSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:18:50 -0400
IronPort-SDR: wERVvO0jlWpDERXf41Tf+hzeQn3QOWLDPt5MBUbRy6pjLgFdV/Gm1RVjQ6JoQM4meVECr9ZgAw
 JA37bTSEHc3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148172095"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="148172095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:18:50 -0700
IronPort-SDR: W1h5ICX24ScUN4gJNUGcFMs8dIPpu84dndKboio1jvg/ha6DJ5RREpFS02Y4/J5dIeSq9kPta1
 4MkEKyyKQ+gg==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="321821760"
Received: from apatwary-mobl.amr.corp.intel.com (HELO [10.212.120.65]) ([10.212.120.65])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 09:18:49 -0700
Subject: Re: [PATCH] ASoC: SOF: intel: hda: support also devices with 1 and 3
 dmics
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
References: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
 <20200921161024.GB1096614@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <399fe98f-5577-6616-8539-885cbc89be1b@linux.intel.com>
Date:   Mon, 21 Sep 2020 11:18:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200921161024.GB1096614@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/21/20 11:10 AM, Greg KH wrote:
> On Fri, Sep 18, 2020 at 11:15:33AM -0500, Pierre-Louis Bossart wrote:
>> From: Jaska Uimonen <jaska.uimonen@linux.intel.com>
>>
>> [ Backported from Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592]
> 
> There is no such commit in Linus's tree :(

no such commit yet, it's in Mark Brown's tree and should be in 5.10

https://lore.kernel.org/alsa-devel/20200825235040.1586478-4-ranjani.sridharan@linux.intel.com/

I must admit I didn't know how to tweak the information between brackets.

do you want me to remove the 'Upstream' comment and resend?
