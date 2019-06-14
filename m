Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281C946CA5
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfFNXIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 19:08:17 -0400
Received: from sonic309-22.consmr.mail.bf2.yahoo.com ([74.6.129.196]:37074
        "EHLO sonic309-22.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbfFNXIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 19:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1560553695; bh=OKi+s+cGxKksz98JVSFiCh7uBDfc1CNpGy2kqM/PdRU=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=HNkYrvUL7VmWSrAJ9qO4p0I1Ghh4lJc7R/Jcd9ZCrQCgFUDj49i2MmQSdq1ALGyl+I/7nz6wCNLndMf7DIXLVDJMlAohNjKijwRtuSAGNXC+tdM9cHuNrh2965kgpLBM386CrhP7nMoIiGylEr5p53WHdTTzTLV64vbDoZX1a3yr2hlGwHQBmFpFoew25hpIDDf8LukUcZd2YZLwhoQqWcDGW4E7qEr8hGsbdFj6E1fWNanQenMzpWMXjRcRGjYzzv+egb1jzVQY9Xf4aF7Cx/dDhVBpixGVIuJky5TyBQQ2kunJ/mUZLDvPG0oB5NO2UrvKgNad8oDLJyas1jpdYA==
X-YMail-OSG: e6YOzmEVM1mLCV15yMm4P8UUZo_QODMhMEA06RJaZ.Kf5sXQ3L7q1boZVP.tdX7
 cLH60NWUl8UXr1nMUm4xYR0X.lLcZH8.HXirr3YTsn8bvXfKzZszXE7EaZWXa5.PJnImXvwBAtal
 4.ltfQ9pkoeRv9Z5WpDKBQHyoeQygQ8gtucmEsKF.n00vMNLI_MBx51uEznnHJqVTgPDxR9dzEaZ
 6pnBBjkGb0DYgi9N5kA3rnyde9cF_ZfUCYpalsGHrsSb0aMaGRP.5fWyWU5NXGGTQQRypnsw8TIt
 ctwjHeMYPwu4C9ZM7hnCIdCfU_ug5ECWgJT_XR1oX0xfJ0HPXoLhvMiIzJKDF4XNP3ZfH2CPyRlz
 C5qYSG9SPhOu2vRv6XBiLY2gRDQcE4nj2EhCSB6g83oH.qS6EMi_p9JMgue4b22O4tqyCvCIEbt3
 Qrs3AhqWnaEqISoFABGK4VM9NAMsT9lOSu1py7fn6JQwLKlvv.3OGWJ5AW4BQcowzy0AkcHEDr3z
 S5ORU_LjBwvApLs_cQhmlWkAe9wKytMynUtSYwZ6.Ibkep3ppt08SptGSoc29dIZofKCat.1e5i2
 hul3nzR3faGH7Lxl4RyF3SCjYffD3tDTAgT8D7PsZJ9BNTxHG6T.TbGc9QterInAlEbAixHjMehk
 i6J_VYdfb8xHTBz_v5PxtzmbR0kJSLVV29qV5ZIyvAhgZZcJl10p6ivSmEKBOt4dqXzEyxiex2Zi
 oAVLDGEHN739Cj.w1fAOPLWQA_uWM6CFGAuGaWCyIM4wb_zc8aksZOl1XpajN9v.ttVzyn4VB4Js
 5KbgtBtELT7lBvztmSf2cvUZw4pSeFC4ml7_NA2w0HZSOK7ft631F5yZGmZ9VP3kYrqnlLqCN8I6
 ENZab0ShO2vdRFVl79Cq.sJotIDnmOeoavx86oOTQFXuKpVpaDYR0TsT52aXA1IhRY.oIYpiFSoN
 omz9U1xOn4BEAI6mcDvL4VcmZrmXzJPM5YurlphFbjtlRy_hfbo7DWJvrtuoVJKXlLTxyV5ByHHk
 QfNRTW6DV1Blr2EATXTFkeiKPJPDxaeX6FViDXaTZcXILYFobm9aBUBYpEUlReQWCcsBQkDJsBTE
 tntiMyZJ0LP4iAhIKzT6NjeB7hEnR0BzcA_ynBosfwiTlgT2Jy.eYlHb33BK8_Xr.aO306ywNX2j
 9VODmFKiMUOgn.M4_NItllidV.D.Cuyz_h4PmQFF7Rl_vL2x5jFX96NPLGDiYHkcJWCo.WeaOtwL
 Eu520LZ9bgkfd
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 14 Jun 2019 23:08:15 +0000
Received: from c-73-223-4-185.hsd1.ca.comcast.net (EHLO [192.168.0.103]) ([73.223.4.185])
          by smtp413.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 993d524de2e3f8c69b010f26dc1e813d;
          Fri, 14 Jun 2019 23:08:13 +0000 (UTC)
Subject: Re: [PATCH] Smack: Restore the smackfsdef mount option and add
 missing prefixes
To:     James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc:     stable@vger.kernel.org, Jose Bollo <jose.bollo@iot.bzh>,
        torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com
References: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
 <17467.1559300202@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1906040842110.13657@namei.org>
 <6cfd5113-8473-f962-dee7-e490e6f76f9c@schaufler-ca.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <cb3749a6-e45b-3e07-27f9-841adf6f4640@schaufler-ca.com>
Date:   Fri, 14 Jun 2019 16:08:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <6cfd5113-8473-f962-dee7-e490e6f76f9c@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/2019 4:07 PM, Casey Schaufler wrote:
> On 6/3/2019 3:42 PM, James Morris wrote:
>> On Fri, 31 May 2019, David Howells wrote:
>>
>>> Should this go via Al's tree, James's tree, Casey's tree or directly to Linus?
>> If it's specific to one LSM (as this is), via Casey, who can decide to 
>> forward to Al or Linus.
> I would very much appreciate it if Al could send this fix along.
> I am not fully set up for sending directly to Linus.

Al, are you going to take this, or should I find another way
to get it in for 5.2?

