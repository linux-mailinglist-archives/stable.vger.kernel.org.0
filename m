Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C1065DA01
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjADQiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239521AbjADQiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:38:13 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89D012AEA;
        Wed,  4 Jan 2023 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672850287; bh=FxIGK5mqqgMrCXSByHO/CJHqUJoNIGhmxTXqeE+dcEk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=gMptfR1VNG8M/eBJBhw87mFtaOySwAZQoVTtMxCkKpsg4NJElezK6uRbnh2fDWWQj
         EKqi0m4fIPojQP/tDE7bNGb5bkxGWQ15PAIlZ0pt0Um0S+GdFk3vkefYPalpsBHi1b
         GfXt7CwSiyD9D/IbO0LiH0PIHNnlbl8q6C972qCmShkIv02uY7r9d3zTS5gOPw+cCJ
         oi3nc/PwZu1QOX1/rq55cjYtWhaknnWG9eMRxentaSC1wdOH280piuO5ew0OAMU62p
         kfPKnxFRFYtKsyiAQnCKberrunGyqWU8ILligfloXCaQhxHEPuQi/mpO4pB9hmajuv
         5rGPfkLBmdvUw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.216]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0XCw-1opxl43uGi-00wSqP; Wed, 04
 Jan 2023 17:38:06 +0100
Message-ID: <9912a3de-d21d-bb15-048c-b9a275ecd725@gmx.de>
Date:   Wed, 4 Jan 2023 17:38:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: PATCH 6.1 000/207] 6.1.4-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:eFw3LtaNxnh2cRii11uzly9Kl+UcqpD2smxRLJqFqYCUvOSR52L
 DsN4OzeFhEdq2h4r+VkfMJHyBFYEXxaVZny0DQC9ziReAzYtpvDemh9nh4GrFjJXlUFZmhR
 rbhDB88C6r15OOhs82emH+Bw/VXapWYCmD0Vz70splNpbqlh3W2DrpvUv3lwtWgPnNb+lcO
 LaGwz6AzITElyPoZIfSSA==
UI-OutboundReport: notjunk:1;M01:P0:1ZktZi0QhA8=;lZj9pjw+Ne3Ur57YgMjYzFZBSJR
 CkkMObpO5sxy7sAw4pmsbDx+6j/tfqUYFRIzo2pen5HmjuT5G5hH8yykFRX1JyexPETOvHB7u
 7vyNH+OzXl0ylBvpeOO1CdTKebEKto7pGpw5F0ZN9+u6VVfDlBtNcUYzpq50GZTUHQhRW2jSR
 yZUM9ozfb4McC5elwxe/RPiIA0fk6bb3Y16PCDhMkgBJ/cGZSGeL1R2dyf/YzcjCCAr93M8Ly
 XcEN8o3Q0IcDFuoABlQKsYOTYKI74QXC+47fOVvqA+3+a5tTD230HRRCE0AUv1q6rJBarWxVS
 h0C9C5qBAu4oEm8KAX4IcxiAltIojNUDklwqjKUw6ujqeVcDH0MWK8DGkGzGDLzc/9nIdJLXe
 2bGcY9b1koKYLccF5uTnAZF8GhHEQTVR1THgOFqVhpkr9MF6+oQ5tdBpQ9TS596XNMnSU9k+u
 vqEwYZ5EvmHiAoz41z8rghlzqirrrJg0gBUVqzAgjy3vD07yILAJ7RfQqgdT6tfe41l6PnB8D
 lHYPluRimZuhsvCoVJ23xXoeBN9YS5ntGthwRHSyA1h1nsXe7YPBM50TqNTl1rJQeOFwUzy2M
 KqLbLOcfiGGmIg8s5e2QRJz9Q5vXXeWCFDZOcH+35DF0PrvcF4XKO3FPaQulWAOsmkcZOdkQx
 jNRtDJucA2wTbi+jzWCSgg1VBUD81qOFPc6pkHYjB+OmWFFeomf99wLEVitgNs22Zt+lsYvHe
 gEGT1GjdsJ8FVMicGQH+NSwyEuq9fpps+ggmC5t5PKIk+15cg6lRDj+2WT9G38eF2fmobslqP
 bnrTy1szSi4gxMkzf1aaDfPbwMMGfWCVKSAVmD2JtAUJvwY92BH6QSOKsOz7lH3thQZdQaUAR
 wjoHFMEjzVWbxSKgpfbvlL8OSehibTXdbbsN2McmiWZOh7BixljtGQqENFBE5Q2vnjZ7alAct
 QJ2xmLLjOwOCTBlVVzib6Z8LOUE=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

