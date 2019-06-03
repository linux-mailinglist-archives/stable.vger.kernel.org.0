Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D5033BBC
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 01:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFCXHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 19:07:38 -0400
Received: from sonic302-9.consmr.mail.bf2.yahoo.com ([74.6.135.48]:37681 "EHLO
        sonic302-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbfFCXHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 19:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1559603256; bh=iAKVJJmKSNaUAJbHvYvdpTwceiT1Npldru+UQuZ4uHM=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=WS86WhAiOCKpE4CRInGVOqSlCGbwECv4zkjw+KzPgo23xDIItCJ9wZIymCTUs81KrVrBEIOCi9PReAdT9uxl0RLT4mQM2vRICHdMQbUGmtH3RHgIsm/Kk/CprQJO1izJ4Ec00PAY9z/CGeQNTpee2dL0fYkjutdKtb/0sDNREeAJInSVSIjGzt2ts70STNC5DhisMczSEQfWTvuEytwe5vo4BkZTZr/RyXB4Taq/hMhTW+/eysqUlVu8uPwFbWmiAZ51PzT/n2vxOIO660DJ2vpV05ee7Ocmcv86XBiGy37HxZ0/jbUPFTFI+EwHBq4C8axLP0eL3wUDaxoXxFnJSw==
X-YMail-OSG: qXvPzssVM1k3p4cLuH2OOn.7aw0vk.oqkptXw1.lxtmSla7nSw2h28PnpX8oUBX
 eNu_TlujUHp3PS_L7ckxxhgfljtnrnl9OtZeSygCIyp3Hz_St56MhQTBpTKwnrVAJO8WqqRmOqvR
 QKiit.Kg_zLiE0AgzCQxGiB80c1a3A6Kn3v8XVfvJe5Xu4B4ckdmKZc88zfeDQOQOzyjCs1H_Wbo
 ctTLpHCr1MmpiducdrVKmurIqkHIs3L6KeTof3cNH.O5DjUXA7j9h6Rjee0XjROQZY7r5EJdEzsj
 XCzScGX15ztJbvfCnWQd8ZG83OymeROb3EYI4BRigvtnW4qX2nTU3zeV1SQXKjyr3y1b12qDN8Yq
 d3YWF6554ECqFmjQefO2_RR0H5s67smeYoWaEMzx8fmRphEMqi3bMu.Kfyz0lEuZG35UnzjSW41_
 nLhwaPLUqmp58BL.uJJeR_5clacWZd4sikZr.4VwvQGWKQsyxRTuSifthJNLKVmGaqkyAlSullAr
 NrUc8lurKYeuLLgIkecY99MRP9eMtjGCpkO3BVP0yzMAfvIBdebQtk89op6ViL6VUxcUw9NaXwIK
 qCRU.L_Kdeon1WMAV0fanZkWuFCYoMcxhmo5OrkwX4aasRIo5Hb082cnfes0Ivjyfj8o1NALtsc6
 sYDjkcIJXd8Dy_knYSceNvu_x0jkmDef0cC0b.7W5oIeS27BkLlwcglrpVYx4VVPzmM_8Vr2cHrl
 i_1mNuIruHc_mIUH9SKkQeEq.YQ88vakbj4o7EcQvHf4r1LUg7ioJQUmoV.WhuJSHqaqrZJDq6FT
 2RjdFX1dFmZa_h_jFpgkNF50F8kU6McXXh6tB6yjqTugCN7HlW5w9LCjRA6WLXAfKw.MstyshQxK
 IfUQE5D8gfpOixitFxy_Fbe6uO_K6Vv5aQKM60oBrclZoAez1HS2vy1_68xBNDnxm7CSDosTH9qO
 wQT2rtPjzHOJbBBd27U1h.vbIHU1PEIxvJXcjp9VgUvOXzzLye8_qp5a7yf11sOxTJMr6LfvftYC
 wCs0ooNuOtttbCUWrPsrewGXg7RprbM1JNyQ9FeP5SZutOL19suanCcYivNRXTE9A5dTXVdtfggk
 Twa.bl8EhnB5og3xDjs1YqqbUYDM7PqO6qy7lF.qKSO_a_a9meksN4W2rqloMCJHHsbXWQkOU2eN
 zCY1z2cXfbrIvJ_xRcheS2d1uTRfXaYHcSI8XLxfjPx7ucXDzvLrlkIlPBaXCryhupvsc_grvdi6
 wjQ.7CV3_.1nDixd9d2G72Ow-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Mon, 3 Jun 2019 23:07:36 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp410.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 1c5b7e8f6a7c6437d9ded3e20076f616;
          Mon, 03 Jun 2019 23:07:32 +0000 (UTC)
Subject: Re: [PATCH] Smack: Restore the smackfsdef mount option and add
 missing prefixes
To:     James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        Jose Bollo <jose.bollo@iot.bzh>, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com
References: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
 <17467.1559300202@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1906040842110.13657@namei.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <6cfd5113-8473-f962-dee7-e490e6f76f9c@schaufler-ca.com>
Date:   Mon, 3 Jun 2019 16:07:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.1906040842110.13657@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/2019 3:42 PM, James Morris wrote:
> On Fri, 31 May 2019, David Howells wrote:
>
>> Should this go via Al's tree, James's tree, Casey's tree or directly to Linus?
> If it's specific to one LSM (as this is), via Casey, who can decide to 
> forward to Al or Linus.

I would very much appreciate it if Al could send this fix along.
I am not fully set up for sending directly to Linus.

