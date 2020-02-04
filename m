Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3991521B7
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 22:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBDVKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 16:10:15 -0500
Received: from mr85p00im-ztdg06011801.me.com ([17.58.23.199]:60979 "EHLO
        mr85p00im-ztdg06011801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727468AbgBDVKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 16:10:15 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2020 16:10:15 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1580850144; bh=NjTbcPMwXg1xHcMH+GO5iNVnEpYUVaqGguMOMHOYsoo=;
        h=From:To:Subject:Date:Message-Id;
        b=lcHQFzeRhKsls4srgyrPml0E7UPa+5y3cyJ8z7vhkERuys3W07dO50h3Xc+nzmN2T
         h0C1Ss4xx/9vpBHE6+faVDIGVeDETCN+zxKE0qWkKMCXvdmSngiu075i2qPrJYVjrJ
         MdVgoJqHaFKyu6Wg5v1IWAhPrDj1NHImBTLWhwjVVQhmGuccfyc1Dy1S1pQpfQfAX2
         0JI57NgWZVjpqhTzPt81lsedEQXqPXDHFYl/Nj7oPXke7tTU4Ubm0XZsybwA7K0Pyw
         LZLX6NICpp2zHsCTlEjOHS6n+DTxrOHwg9kNNM6Hpw9JW3rhBmcXsgKmCrj8hnQSer
         /kH91t+a5/0Rg==
Received: from stitch.danm.net (c-73-98-236-45.hsd1.ut.comcast.net [73.98.236.45])
        by mr85p00im-ztdg06011801.me.com (Postfix) with ESMTPSA id C827BC112F;
        Tue,  4 Feb 2020 21:02:23 +0000 (UTC)
From:   Dan Moulding <dmoulding@me.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, stsp@stsp.name, sashal@kernel.org,
        luciano.coelho@intel.com
Subject: Re: [PATCH 5.4 61/90] iwlwifi: mvm: fix NVM check for 3168 devices
Date:   Tue,  4 Feb 2020 14:01:57 -0700
Message-Id: <20200204210157.31658-1-dmoulding@me.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-02-04_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=512 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2002040144
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I believe this commit (upstream commit
b3f20e098293892388d6a0491d6bbb2efb46fbff) introduced a regression that
causes the driver to fail to initialize for Intel 3168 devices. A
patch for the regression has been submitted to the linux-wireless
mailing list here:

https://patchwork.kernel.org/patch/11353871/

I would suggest either not including b3f20e0982 in the next v5.4.x
stable release, or also applying the above patch, to avoid introducing
a regression for users of the v5.4 series. The above patch is also
needs inclusion in the v5.5.x series, as the regression is already
present there.

Cheers,

-- Dan

