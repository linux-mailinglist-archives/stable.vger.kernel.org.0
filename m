Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9E9FF44F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 18:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfKPRUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 12:20:42 -0500
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:36858
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727810AbfKPRUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 12:20:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1573924841; bh=6u3qDl6yXWBH9oVBF6VmNFaXPPfmaUEmS0LDo6+oXlw=; h=Date:From:Reply-To:Subject:From:Subject; b=aQqPKV9T1iy214J3n9YkK6BLkWXjpz9z1zBcatcu5TR1WLNrKgjzSaKCgO8IDdks7GIMgSMWhFdnVCmiZ/lyBZXzrvOm0JWa1+ltW3NEa/48VhhfI+OVyYEzLnAQ3q+8dSVmwXWCs9djtOJvO9nk0jl1HAbmmuIlFYU1jsVHQZL0hk8ySvgeYyp9W8eraWOp6TnT+BIM44e62lfpOcGgh+qB4z5F54VWuTpZNFbq3CEZUX0Boz8UJWOzLv3A3epJnMSH+1R0z2xuqgUTO7Lk9Qqxbih246RLbLzQ4bDeXeC/++bMi5+hNq0rCIu0n800lgp3HyIESJH8l6g0qLPK2A==
X-YMail-OSG: VECK4ewVM1m9xXD_QYaYZppCkWV84.YnvJEprDeS.dxfDbakwYbI4dKhAmSfeMz
 hBlTUYSSzNDPzT47YiWAJ2whmIURl0tLVhGEgdEpTavpa181h..Dpd5BF3IBrCKL9gZ7NGzMxREy
 q8XRi0y3cTznAqZ6g0YCQo5DF4PfpWr25mBelbLJIMTNx0sD0dRedsUs0VRHP.5AMbgaLI_Tudls
 QdsL8GCOm_1yCwwrN9etgL4pUbCofdsWE5THW7kjzlCfV_.YIM1PSp3XUtY.L584LGL5bky1vMpz
 QQNHKOz3qFo.mKUEUs4LH1ZZrXVhLXsgEnamhWAllD.XmUctLxkTBoNJsCxHbSYqDFkFO77fKdLx
 aOQ1XiswIVJq0WAqTwGoN8g6Z7xJO6LbZPUbo4v8OFzsM5EwFHFzX6S9uNBF6zSS_kSxvC4L5u4z
 uwNnEJiVMdK3KA1Q26M8USpgOm6gdZKvkEgxcrN.wIXb_CwzRKqLGXediFEfZUrCKW_k9JvCZIZk
 q64k13UpPO.5S1mW_57FCM8PApwzHzzg91xvTfgn14J_ybZxNUumVJDkS_30IxyJPJxiw98UIQPR
 ueAzIMmu3pNXxxZvb8RfOfKJ9MyzQJ51_qqxrGC_832mqzRmnwDbamj1N5jB34HfX8Qp5O3hfHJO
 n7rAWsWbMb6a7zgyyjthbbqY.7niEWGUou2CQl1tZc1hj2rE3p210mI9VawEZ2DS4lmspYraWzDD
 4ep1ItN.baDMaaYxQaWjJhFV3pHyV281zqrr_IyteUYSuUHXPU_n5cYebwHeVEx6Ff8waeOumqNl
 mXRPA8NqEQXC2vEnDvSvbdl.ai.f8hKhQSBiVBClojmk1Be_5P.q3AJNLUHWd36PrvQ0yIvCqU_u
 VKN2Gfxy3_L6GsIBwJuO5spnCsr.RJ00EwI.95DVoEIPEuN2_HbYvWQbtsvpH.4GcUh254XfSbmp
 ezML40b6J_4KJNdLLPfFktZEacqxq.e_MKJp0jwk9v9OLAzPG35C0U88TmWo3IXFEPSYpdGeiDSs
 ROMjI849GFyEeEV62_yM872tcPhDubSSGfpqYN4ejP8RjPhL8mQLIOBImZUWY8jDyDcFHdzDrzRp
 6XlVC54RVI3UsPEuUrFsaXZDb.knRMvkPTYNqUU8YyXiXCdlpS09tRclhcJxz1aNvGdxgDdLT9cG
 G2prMYmPNzi_xDuW3DumV3LdiXZsFNFztOE.aHxm7xjID3s0IsQqdl4riQnA2hfuQ4XNEZcSq7iB
 GPA4wSlb6PktABHMlOR9ex5hFpNIdZPBkau74GO5ezQa3btLrBGi0lB6_0voVQFayZKSd0h_Awr5
 ad0PdtFD68A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Sat, 16 Nov 2019 17:20:41 +0000
Date:   Sat, 16 Nov 2019 17:20:39 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1063556625.1154042.1573924839152@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION BENEFIT.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment and the amount is (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other .

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
