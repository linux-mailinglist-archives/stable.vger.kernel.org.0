Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B853A6DB6
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 19:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhFNRyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 13:54:55 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com ([66.163.187.38]:37210
        "EHLO sonic308-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233985AbhFNRyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 13:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623693171; bh=CjI+Y1jLzQZocS74biMFxJXGXk33MszEbV54guTry/M=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=QF0aq9cOL470KhgZJafw1sqoagAhORXoHQqeJlG3pMcwhrWDHGNRH11/uxi0BlOfqRJgGu7Le6l5TjWNgwqka5Ssz4C9n7gvTW1SWt2PQq+EFT45CQdoEf3ujSkk7us7LLr/Gq5zs2MPRXR9WNQrrKJ8lzIXUBB4yF7cfpx/P+IGY1l1LIKObF2Rv0F4ZYuRf9rQLKZjxwK4eo8u7skdghMWoGkzHBOrUZZoOR1A3PY0k2Y0Abd/yviRpPnl9eRLDC51Yg+jihQsZzPU7z1qEpTLT54edc9cfkNli+euib6VL/m3OjiJlWIKMWyyEJUIDt4yHSQdeIXaU6qSiaUeoA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623693171; bh=oGBvXpwGugeJMD9uvUmVrWkmhJqjqHrIQdTK3p1mAjq=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=SaBYfuU64y9DsnjFIOYgRPzEXiym4AuTIo/p+xMvamKUQERstIRzqNjpKZJdcrz84jUMxFktdp7IwhOSYiosk0GTmz+t+iSbxJO14vF0bwK533aT8daN4S6Rz1wnE1N9xk9nIZUp/f1Isa7soBDDDQJa8qgXGKkw/luHcVAWZhr6as+pxP+CeBOzZYJsBGyN2ReqX/aqohPLNmdOqfEAiRzcnmlWhBtM5nx59k5x61cxE9ERI6afT6RPTqh4T5Mshc3j1vGvkEby/xGGDzklJlC63pfUuAG7SGNQ3Bh5SA7SS+TFnUNpCdX3g9niYJYNurhwdPWJIKoWC/9XByThnA==
X-YMail-OSG: FRLW7QoVM1m5mMLp7iYVQ6BUDdqVW11jKRS0Wk8RdxffzqPBW95JfK15fuo3xNj
 vxHkcSZaCb8xvyyQBxZ3yhASuNvy.jl8Z38TmW5hIAQw7FWFm8UG6WSO.UFly5MKjeZTBevoUmN3
 tuhimYYQK72mz9O8IMVq9z0FUGfA3Ly9HVU1tc3u3uo5NTo_fIu_2k0LmQhL5Hh_2k_SuWEMBJgV
 qANT_Z5igQGGDulYC5clHbKyPBOQWIOGZawqkmqIPKjh4ftNO1YSc5_t8Zi_SeMdjC2KczGST0Gf
 i1Peq3.8bW0x0DmajJ2vXShGgUioAeYByn6mhuHgPbKp3AtsMYS3PHHXuG5utBSLE4GcLWwJkHML
 WZwb701cNImrAxvGwjBP7L8so8c0hsnKUXN1Fc9i3kBQQqqALVG8a4WV0iy6klmHlsshGKGOfX9c
 x8KONJFw4gseB5tUHh6aAA9njWDyw2hdSd_Ps6ZLIX0DrvymqbghLkD94Bft4aQT2G4rx.P7GS35
 b0LjfRjLGi1gDkYcRafyD4mzCSdUrP1O7oLJ2lr56VRBZvXyIZErWR05ydYxu3_whX.v9B5EVPIz
 lX6jtLCivbZ0nuCX7udJFNhxdtmcuSSIEuy01kYuc00yZAC1pVYQcZ.RCQMJ8zYcMAY6APWwLxx3
 zaDXrNXA8NC1ZFCLw9rAFpCBhrP26gVLnQ41NT70ypdLsZSa0W0PextIMElRzfFSPT2NlzfI6KqW
 q0rjfLU_iys57KpUsHIma8HfhIFagU4mWTtrY0lmyR6MvElSuaO_pZc9CBv7UuqXZLOFFDJrPQM3
 .EFtyUty8hAFsq8UAYrXzIOAbKNQGxxWx2iekb3CB_pY0AVNqvZEGWcQHdlxZ0naXjGrlOTaoQP6
 Ti0plcxWcVrXEeiy99noUX8VAcVgvzMbwvObzMvbwHjbMFwIDR2fMYOY.0ta5rC7cgndpYWa4.CH
 0Yeo47dwYyjfBxxAozYyWJAeCZk3xuHcDYoCK.BiWBgZ.l6YdCipD4GwmCdBmSJr9yR3s_nystHJ
 .prvudAKc5xpbPv.ydX1QTFf3xVQxtct02.pn.FPl_ZlNFAHOcP6fCNrjT3hp0Nom9SWiD9D7gCe
 4xtEPybqvbo.HRb6kxjnxkY2xUv8_7w1NDQgGQuxUWFiwk0JnhLWRQmhOhw568H517ftw7wWKr.0
 I_aN4TXgunwdBQfWmtwHbUg1RLrZd9nekfbT7hWndGMp9i3LT_S8VvPy87WhS4XZhvgR3GrUBa1Q
 LZN.rFsYaTyVrNJevcvtb2IhJKI2lMbiBl9LI2xjzPAj1i_w2xzoOBqeYMp_boVpwoG.mXmYhh0y
 jpUSRg4QxgbdoYWUkCtOw85ZRhumoIFX3H4pd.u4vYm3FXc01jdKdgKH79peil3Q4KKgEOUpNQzl
 zIKMgGdkG1mm9MKPfLpZ_oSxLl2U6vX3HM9V1aTdB0ZOh59JZ4TC5Rd5x0UEygdnAPtgOLvbzjk2
 5U2BqHJeofsF_5zf62Atg5Y7H9Bzmf4w._L0yMcUD_7bpPwQWzfW1pfA7g0LkiElDqnoBMs9T.1v
 TXiKsPrIzoIo92MhgX6_VoF__FjC77JhjOK6mjzEJNTJdpxzx6Jv00MrkGuR5GJttqVr66WL6r.6
 ShRJ5kOtGn2bnl5Kj2mNWZ9RJL_Ne1Pyfh5km4EtzSfCdH_7J0Gi0LUKD9TMPjzjHBEryKtBxUjL
 54z85r5ZQETvCH5WwdFM3fC6.SY2QaiBGyhWMlplhMjd96qG4luq6KuWL8zNOApZcwsqgClOLTYP
 ZH.R8D3UcYzo4Re2BTFavEn0ig5RYQ9Y7sarKk3Ji9R_qiu_3DiujPggm8vT3sTL7CdevoBjkv7v
 N1tAURgsaP41PrM7PuQhXp5TRZPVpFVYnzZfK.FFwoG0PkhsGqZ7r4kUr7Lt.uqPJwWyTFG1INDq
 PDSkOBThYfVt4fLoOMF7GTmxt4Rkc2ArFbUUgxLJHV1DLOoUttZd6bKwyctE1HIeiJzcakSgLId0
 Q0ASRLY0xQVMlQs6ckeGFeMOj1iPNEJuFp2nFrhKMPCtRyjRsHY8r9MwdMJXeDGFxksMr6J58DEd
 UPCObOPNrH7oElSaHbahipnLD5jJ1nv8MFjXojschLDcmO79aR6Ql68MR7n41TY0NKMOB8EkjA5n
 DTK2jPOcA1PXLnmIyWti3CJQI08Rq8PsRbD2sJd0tmSkYD503f5jY5ndZSi4iPL2x36LvITtaymu
 uDBwpjvJJC2YVIrK.UjcEvr3CDJH_JnyAra5G5S5CRAbM7fVGc9zcJyWEv6n8YZWzK7YgniAUWHn
 X5gGirnm9gBzwaEXjYtFRm8GuOSPBQjPMTd2eo93qSrNbu7DRNBYhCX5o3wTI6OPGXA1QRrBmszh
 UxcDqQrJRy9615oqCclMV_424Ijb7W4E_KJxu_8lSwKaGPhPVoHU94XpIeeirDbGiGxwC_VQRPqr
 RP5jYhOcIKXFN2ZiBFFNfNzpsaGuO4J.GdWAuTGob6fBimpXFZZGfMAbUkBb6EuX07ianmDvsMcI
 fmT5FoCkstJVBj7oczw7ZqeysWV4tnR.WahqSCXjYtSD1UiFO0qir3dSs1VlL6S3Dg9C4H8LUuHZ
 UAEMWDYrta1Ad8qGM42OksMdViRupRWF2w100vZqC.0Lb0yU6_sSV_3FzElbtn7pfNy4edESJRqA
 H.Nz4m795vqsdPVbZ3DYu6KAhTKfP8VCmt.MKmiS4N84hkcL281X8qvaKhqk5nOIdt08YVFupyRI
 dj_wLaOicyTfIUjYDWqkDIMGiZ254HoHe9OWs76NuayaPhniLNz4atCb.tAoU_uZwrLfvnoEfQnj
 pQbWapn3E27W.ENYP4HoJC9n9XkPeO2ycMz8Yz1hnbTisQMtOOLglllm8gwrtqforIazyOHxnmqK
 TxPzGOxJOqtIOmGaQOJIzrJtRYSrQiwCDILlk2pjV3eObjsyaFj8aXQ6S0QJuR.6sZH.9RTGvzXj
 Dv5Dk9rg_ne1w4gzgspibn4PuSrkAD8xWPz8Pe.8s5nvgSRaGlQ2r9xmAsCBmobAAr2rJLNEuAUG
 Yj6mrC.tuIQl2EMiANKYBZexVeUqsjsrwWrEsNUKUWugdXDUlYOye7j6s_feYlhe8ni3lY3EECm8
 Bd6TOsu3KeVyfFMYMzKVBXCyoWUN9p5eIubDxTADZe__hr9FIgw9xt2CviainGMj4HBT.2A_sC.4
 tw.gfJtVhWztD.CCNTekoYSne2rRg9d83n71YhYtHr7i4fdeUX8C4cKSgEcr.uSlOKf1KpAEIiFZ
 UmdNLdHXhVDEnqAb83DThk78qVi5N4QOzOsbLOiiZl7M438D9CSYVwu63YR6M0mGg6HFni2BuRSq
 rg076P4Wf8lHibWTjWLVdJpHWP.xtt6M0E.GT5ILMKW2WEkBFFogC80ltQwCMh3XVmyU-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 14 Jun 2021 17:52:51 +0000
Received: by kubenode545.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6300d772aac7e5202316b0b855d6980d;
          Mon, 14 Jun 2021 17:52:48 +0000 (UTC)
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
To:     Kees Cook <keescook@chromium.org>,
        youling257 <youling257@gmail.com>
Cc:     torvalds@linux-foundation.org, christian.brauner@ubuntu.com,
        andrea.righi@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-security-module@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com>
 <202106140826.7912F27CD@keescook>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <17222cd4-3c2b-9d0c-aa51-64b7a50a9c2c@schaufler-ca.com>
Date:   Mon, 14 Jun 2021 10:52:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <202106140826.7912F27CD@keescook>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/2021 8:32 AM, Kees Cook wrote:
> On Mon, Jun 14, 2021 at 06:02:34PM +0800, youling257 wrote:
>> I used mainline kernel on android, this patch cause "failed to retriev=
e pid context" problem.
>>
>> 06-14 02:15:51.165  1685  1685 E ServiceManager: SELinux: getpidcon(pi=
d=3D1682) failed to retrieve pid context.
>> 06-14 02:15:51.166  1685  1685 E ServiceManager: add_service('batteryp=
roperties',1) uid=3D0 - PERMISSION DENIED
>> 06-14 02:15:51.166  1682  1682 I ServiceManager: addService() batteryp=
roperties failed (err -1 - no service manager yet?).  Retrying...
>> 06-14 02:15:51.197  1685  1685 E ServiceManager: SELinux: getpidcon(pi=
d=3D1695) failed to retrieve pid context.
>> 06-14 02:15:51.197  1685  1685 E ServiceManager: add_service('android.=
security.keystore',1) uid=3D1017 - PERMISSION DENIED
>> 06-14 02:15:51.198  1695  1695 I ServiceManager: addService() android.=
security.keystore failed (err -1 - no service manager yet?).  Retrying...=

>> 06-14 02:15:51.207  1685  1685 E ServiceManager: SELinux: getpidcon(pi=
d=3D1708) failed to retrieve pid context.
>> 06-14 02:15:51.207  1685  1685 E ServiceManager: add_service('android.=
service.gatekeeper.IGateKeeperService',1) uid=3D1000 - PERMISSION DENIED
>> 06-14 02:15:51.207  1708  1708 I ServiceManager: addService() android.=
service.gatekeeper.IGateKeeperService failed (err -1 - no service manager=
 yet?).  Retrying...
>> 06-14 02:15:51.275  1685  1685 E ServiceManager: SELinux: getpidcon(pi=
d=3D1693) failed to retrieve pid context.
>> 06-14 02:15:51.275  1692  1692 I cameraserver: ServiceManager: 0xf6d30=
9e0
>> 06-14 02:15:51.275  1685  1685 E ServiceManager: add_service('drm.drmM=
anager',1) uid=3D1019 - PERMISSION DENIED
>> 06-14 02:15:51.276  1693  1693 I ServiceManager: addService() drm.drmM=
anager failed (err -1 - no service manager yet?).  Retrying...
>>
> Argh. Are you able to uncover what userspace is doing here?
>
> So far, my test cases are:
>
> 1) self: open, write, close: allowed
> 2) self: open, clone thread. thread: change privileges, write, close: a=
llowed
> 3) self: open, give to privileged process. privileged process: write: r=
eject

I found an issue under Smack where a privileged process opened
/proc/self/attr/smack/current, wrote to it successfully, then tried
to write to it again, which failed because the cred has changed.=20
That's not a common use case. The usual case is open, write, close.
If ServiceManager is assuming that it can leave a descriptor open
while manipulations are in progress it could encounter the same kind
of problem.


