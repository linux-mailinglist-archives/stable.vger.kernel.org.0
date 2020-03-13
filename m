Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3CA184A75
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCMPTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 11:19:45 -0400
Received: from mr85p00im-zteg06012001.me.com ([17.58.23.197]:59725 "EHLO
        mr85p00im-zteg06012001.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbgCMPTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 11:19:44 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2020 11:19:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1584112406; bh=c76E9YPI/nRjNsAQDgxmcgVuidhmXFzQl5uvAz/dnck=;
        h=From:To:Subject:Date:Message-Id;
        b=Mj3ldbWoJz+P3Yxjxn7if64njeYjzAVQp9F891tNCbvplSeo8sfLxNkhxOseMDflW
         mVwaR5JAckVLZoD6PNJqCSFsRWKumZzdn0pBwXsHPAbM1zbBhT1+IZYCE+ZdcVS167
         vDTtkLkRqScUUQSpOgj9TrEY+X66oaUDF8ev1jdOZdkLtGXY3OTAMmkBW7IBaBFv9V
         qhflFnauQHDtyLQhvimHe6dz2pZ3Bq98BGivz8MVgHTO0s5r8fUeoCEzcVctG3J5xt
         Bqj18eaEqREr0Lqc5JBXFGZWR5SHZyDpGrgJSAgwhUUho/YYrYa7ZxmM4GmmCfBzad
         6x4fw4yeK13Dg==
Received: from stitch.danm.net (c-73-98-236-45.hsd1.ut.comcast.net [73.98.236.45])
        by mr85p00im-zteg06012001.me.com (Postfix) with ESMTPSA id 5A9D2A00458;
        Fri, 13 Mar 2020 15:13:26 +0000 (UTC)
From:   Dan Moulding <dmoulding@me.com>
To:     gregkh@linuxfoundation.org
Cc:     dmoulding@me.com, luciano.coelho@intel.com, sashal@kernel.org,
        stable@vger.kernel.org, stsp@stsp.name
Subject: Re: [PATCH 5.4 61/90] iwlwifi: mvm: fix NVM check for 3168 devices
Date:   Fri, 13 Mar 2020 09:13:00 -0600
Message-Id: <20200313151300.18957-1-dmoulding@me.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205093102.GB1164405@kroah.com>
References: <20200205093102.GB1164405@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-03-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=662 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2003130080
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05 Feb 2020 at 09:31:02AM +0000, Greg KH wrote:
>On Tue, Feb 04, 2020 at 02:01:57PM -0700, Dan Moulding wrote:
>> I believe this commit (upstream commit
>> b3f20e098293892388d6a0491d6bbb2efb46fbff) introduced a regression that
>> causes the driver to fail to initialize for Intel 3168 devices. A
>> patch for the regression has been submitted to the linux-wireless
>> mailing list here:
>>
>> https://patchwork.kernel.org/patch/11353871/
>>
>> I would suggest either not including b3f20e0982 in the next v5.4.x
>> stable release, or also applying the above patch, to avoid introducing
>> a regression for users of the v5.4 series. The above patch is also
>> needs inclusion in the v5.5.x series, as the regression is already
>> present there.
>
>Now dropped from all trees.  Can you send us an email with the git
>commit id of the fix when it lands in Linus's tree so we remember to
>pick both of these up?
>
>thanks,
>
>greg k-h

The above fix has been merged to Linus's tree and needs to be
backported to linux-5.5.y.

Commit a9149d243f259ad8f02b1e23dfe8ba06128f15e1.

Thanks,

-- Dan
